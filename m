Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbYHZOMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbYHZOMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYHZOMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:12:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2989 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753139AbYHZOMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:12:37 -0400
Date: Tue, 26 Aug 2008 16:12:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Avi Kivity <avi@qumranet.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826141230.GA5478@ucw.cz>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com> <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com> <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> <48B40631.5090007@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B40631.5090007@qumranet.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-26 16:33:37, Avi Kivity wrote:
> Maciej W. Rozycki wrote:
> >On Tue, 26 Aug 2008, Avi Kivity wrote:
> >
> >  
> >>Most machines are recent machines.
> >>    
> >
> > This is a bold statement I would say.  Any numbers to 
> > back it up?
> >
> >  
> 
> Only common sense.  Non-recent machines are barely 
> usable these days.  Sure they work well as a firewall or 
> server-in-a-closet, but if you run a desktop or a server 
> that actually does useful work, you're running a 
> relatively recent machine.

reboot needs to work on servers-in-a-closet, too.

Anyway, I guess the change should go in. Lets see what breaks.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
