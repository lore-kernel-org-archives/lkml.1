Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbYKKU3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbYKKU3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYKKU2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:28:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYKKU2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:28:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [0/2] Hibernation patches for suspend branch (was: Re: [PATCH -next] Hibernate: Take overlapping zones into account)
Date: Tue, 11 Nov 2008 21:30:25 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200811081356.13060.rjw@sisk.pl> <alpine.LFD.2.00.0811111300580.4480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811111300580.4480@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811112130.26074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Len Brown wrote:
> 
> On Sat, 8 Nov 2008, Rafael J. Wysocki wrote:
> 
> > Hi Len,
> > 
> > Please add this patch to the suspend branch.
> 
> Please re-send a checkpatch clean version.
> 
> Also, the comments on this patch (and the next) are mal-formed.
> The commit message must be before the first "---" and the throw-away
> comments must be after it, rather thant the reverse.
> 
> I ask others to get this right, so it seems most fair that I do the
> same for you -- otherwise your next patch will have the same problems
> and others will follow your example of not sending the "perfect patch"

OK, here you go.  The following two messages contain the updated patches
(still, 4 out of the 5 checkpatch.pl "errors" in the first patch were plain
wrong IMO).

Thanks,
Rafael

