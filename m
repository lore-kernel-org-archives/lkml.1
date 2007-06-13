Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbXFMVCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbXFMVCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXFMVCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:02:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58504 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751643AbXFMVCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:02:02 -0400
Date: Wed, 13 Jun 2007 17:01:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Paulo Pereira <pfmp.404@gmail.com>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v3
In-Reply-To: <20070613203501.GA5708@suse.de>
Message-ID: <Pine.LNX.4.44L0.0706131659570.13726-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Greg KH wrote:

> On Wed, Jun 13, 2007 at 09:58:05PM +0200, Michal Piotrowski wrote:
> >  USB
> > 
> >  Subject    : list_add corruption. prev->next should be next (f7d28794), but 
> >  was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
> >  References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
> >  Submitter  : Paulo Pereira <pfmp.404@gmail.com>
> >  Handled-By : Alan Stern <stern@rowland.harvard.edu>
> >  Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
> >  Status     : patch was suggested
> 
> I'm pretty sure this wasn't a "regression" and was always there, and
> that the proposed patch did fix the solution, right Paulo and Alan?

I'm also pretty sure that it's not a regression and that the patch 
should have fixed it.  But since Paolo hasn't replied to any of our 
queries, we can't be certain.

Alan Stern

