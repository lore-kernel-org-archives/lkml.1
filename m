Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXFAEGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXFAEGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXFAEF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:05:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbXFAEF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:05:57 -0400
Date: Thu, 31 May 2007 21:05:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Prarit Bhargava <prarit@redhat.com>
cc: "Luck, Tony" <tony.luck@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       David Chinner <dgc@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <465F9315.2050207@redhat.com>
Message-ID: <Pine.LNX.4.64.0705312105280.30098@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01961A60@scsmsx411.amr.corp.intel.com>
 <465F9315.2050207@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Prarit Bhargava wrote:

> I used the sn2_defconfig in the tree :)

That is a static kernel build. Ideal for that kind of bug.

