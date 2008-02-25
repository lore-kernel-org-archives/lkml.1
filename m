Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYBYWVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYBYWVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbYBYWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:20:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57563 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760852AbYBYWUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:20:36 -0500
Date: Mon, 25 Feb 2008 23:21:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, acme@redhat.com, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 6/9] add a loop counter based timeout
	mechanism
Message-ID: <20080225222100.GL2659@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160108.11268.1451.stgit@novell1.haskins.net> <20080225220601.GH2659@elf.ucw.cz> <20080225221947.GA2852@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225221947.GA2852@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-25 14:19:47, Greg KH wrote:
> On Mon, Feb 25, 2008 at 11:06:01PM +0100, Pavel Machek wrote:
> > On Mon 2008-02-25 11:01:08, Gregory Haskins wrote:
> > > From: Sven Dietrich <sdietrich@novell.com>
> > 
> > Why is this good idea?
> 
> It preserves the original author when the patch is applied by git.
> Otherwise the author of the email would be classified as the author of
> the patch, which is not the correct thing to have happen a lot of times
> (like this one.)

Sorry, that was not what I meant. The patch had no changelog at the
top, and I was complaining about that fact.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
