Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYH0K11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYH0K11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYH0K1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:27:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56468 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbYH0K1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:27:13 -0400
Date: Wed, 27 Aug 2008 11:18:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Avi Kivity <avi@qumranet.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080827091810.GB1688@elf.ucw.cz>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com> <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com> <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> <87fxorsqdx.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxorsqdx.fsf@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-26 18:16:42, Andi Kleen wrote:
> "Maciej W. Rozycki" <macro@linux-mips.org> writes:
> 
> > On Tue, 26 Aug 2008, Avi Kivity wrote:
> >
> >> Most machines are recent machines.
> >
> >  This is a bold statement I would say.  Any numbers to back it up?
> 
> You can do the math. Reasonable assumptions are ~10% growth rate
> in year-by-year units shipment (that's conservative, usually it is higher) 
> and that most systems are only used for 4-5 years (on commercial servers 
> it's typically 4 years, on privately used systems perhaps a bit more,
> laptops certainly less because they tend to break earlier). That 
> is the average, of course there are systems which are used much
> longer (or much shorter), but I would expect them to be the minority.
> 
> Also laptops are growing more and more compared to desktops (iirc the
> cross over of more laptops than desktops shipping happened recently)
> and if the assumption that they break earlier is true (it is
> definitely in my experience) so it's likely that the average system
> live time shrinks in the future.

I'd not count of this. When you relegate laptop to "quiet home server"
role, the mechanical stresses suddenly stop, and I'd expect it to
survive for long long years.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
