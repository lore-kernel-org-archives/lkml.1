Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYCYNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYCYNPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYCYNPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:15:43 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:44949 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYCYNPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:15:42 -0400
From: Chr <chunkeey@web.de>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: inotify fixes in stable
Date: Tue, 25 Mar 2008 14:15:37 +0100
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Greg KH <greg@kroah.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       stable@kernel.org
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx> <200803242333.30200.chunkeey@web.de> <20080325004233.GN23462@sequoia.sous-sol.org>
In-Reply-To: <20080325004233.GN23462@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251415.38235.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/BegeSwB+fJrMTJlweT00U0Im56pL0q7A0qgP7
	Ee7yrjGdRzNMXF6Y9Cd0txQAlys4KlJHluw9ZHaeakhp7RS2Xf
	g6JhHGeig=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008 01:42:33 Chris Wright wrote:
> * Chr (chunkeey@web.de) wrote:
>
> [...]
>
> Please just explicitly send the fixes to stable@kernel.org and Cc Nick.
Done...! I took both patches from the current git-tree.
but forgot to add a tested-by flag... well, but I added the patches, right?!

>
> I'm actually disinclined to take 0d71bd5993b630a989d15adc2562a9ffe41cd26d
> which seems to primarily just remove the WARN_ON(), although that is
> assuming it is indeed no longer triggered with just the race fix,
> d599e36a9ea85432587f4550acc113cd7549d12a.
hmm, Nick said that the debug code is racy and "not very good at finding 
problems" either... But as long as the real fix has a _real_ change to get 
merged in 2.6.24.5, I'm happy ;-)

>
> thanks,
> -chris

Regards,
	Christian
