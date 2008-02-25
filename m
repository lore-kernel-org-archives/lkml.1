Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbYBYWUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbYBYWUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbYBYWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:19:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:58073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758682AbYBYWTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:19:45 -0500
Date: Mon, 25 Feb 2008 14:19:47 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, acme@redhat.com, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 6/9] add a loop counter based timeout
	mechanism
Message-ID: <20080225221947.GA2852@suse.de>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160108.11268.1451.stgit@novell1.haskins.net> <20080225220601.GH2659@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225220601.GH2659@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:06:01PM +0100, Pavel Machek wrote:
> On Mon 2008-02-25 11:01:08, Gregory Haskins wrote:
> > From: Sven Dietrich <sdietrich@novell.com>
> 
> Why is this good idea?

It preserves the original author when the patch is applied by git.
Otherwise the author of the email would be classified as the author of
the patch, which is not the correct thing to have happen a lot of times
(like this one.)

thanks,

greg k-h
