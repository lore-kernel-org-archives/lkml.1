Return-Path: <linux-kernel-owner+w=401wt.eu-S2992826AbXDYQXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992826AbXDYQXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992831AbXDYQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:23:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992826AbXDYQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:23:49 -0400
Date: Wed, 25 Apr 2007 09:23:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: John Stoffel <john@stoffel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Serial console problem in 2.6.21-rc7-mm1 and earlier
In-Reply-To: <17967.32856.616216.761311@smtp.charter.net>
Message-ID: <Pine.LNX.4.64.0704250923290.26666@schroedinger.engr.sgi.com>
References: <20070424130601.4ab89d54.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241320540.13005@schroedinger.engr.sgi.com>
 <20070424132740.e4bdf391.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241332090.13005@schroedinger.engr.sgi.com>
 <20070424134325.f71460af.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241351400.13382@schroedinger.engr.sgi.com>
 <20070424141826.952d2d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241421140.13904@schroedinger.engr.sgi.com>
 <17967.29851.680497.648681@smtp.charter.net>
 <Pine.LNX.4.64.0704250838360.24504@schroedinger.engr.sgi.com>
 <17967.32856.616216.761311@smtp.charter.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, John Stoffel wrote:

> Ok, no idea then.  It's working for me in 2.6.21-rc7 as long as I
> don't have more than one console= entry in my kernel boot args. 

2.6.21-rc7 is working fine here too. mm is the problem.

