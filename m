Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXF1MNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXF1MNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbXF1MMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:12:52 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:56949 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbXF1MMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:12:51 -0400
Date: Thu, 28 Jun 2007 08:12:48 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of switching
 broadcast timer
In-Reply-To: <20070628012749.caf450f6.akpm@linux-foundation.org>
Message-ID: <Line.LNX.4.64.0706280808140.11719@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
 <20070628001221.364438ce.akpm@linux-foundation.org>
 <20070628012749.caf450f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Andrew Morton wrote:

Sorry, we should have discovered this before you.


> (Shouldn't this be in /proc/sys/vm?)

Probably.

> My fix:

This should work.

(We have some code to allow things like this to be added without needing 
new policy, but it's too late for this case).




-- 
James Morris
<jmorris@namei.org>
