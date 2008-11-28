Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYK1VvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYK1VvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYK1VvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:51:13 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:45932 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYK1VvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:51:13 -0500
Date: Fri, 28 Nov 2008 16:50:55 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: drivers/x86 (Was: Re: linux-next: Tree for November 28
 (misc/tc1100))
In-reply-to: <20081129083550.3c23af37.sfr@canb.auug.org.au>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org
Message-id: <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
 <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Nov 2008, Stephen Rothwell wrote:

> > On, moved to drivers/x86/.  Someone needs to clean up drivers/misc/Makefile.
> 
> Just wondering where the move to drivers/x86 was discussed, (reviewed and
> tested) and why the change is in the acpi tree and not the x86 tree?
> 
> I am not saying it should not be done (I haven't looked enough to have an
> opinion).

Although I discussed it with Linus last week in Portland,
it is true that this patch erroneously appeared
in my tree before being sent to the list.

I guess I got interrupted...
I'll send it now, thanks for the note.

-Len

