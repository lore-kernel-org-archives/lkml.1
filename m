Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZFRKNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZFRKNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZFRKNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:13:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56255 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZFRKNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:13:14 -0400
Date: Thu, 18 Jun 2009 12:13:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090618101309.GC28892@elf.ucw.cz>
References: <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com> <20090615170103.GE25040@elf.ucw.cz> <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com> <20090617091139.GA4536@elf.ucw.cz> <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com> <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-17 14:36:50, Arve Hj?nnev?g wrote:
> On Wed, Jun 17, 2009 at 2:40 AM, Brian Swetland<swetland@google.com> wrote:
> > On Wed, Jun 17, 2009 at 2:11 AM, Pavel Machek<pavel@ucw.cz> wrote:
> ...
> >> One more question... do you have keymap.map to make console usable? By
> >> default, keyboard lacks any special characters...
> >
> > I don't think we ever put together a full keymap for the console,
> > since we don't use it much.  Arve might have done something with
> > setkey once upon a time.
> 
> I used setkey on older hardware to get a usable console, but the
> original dream keyboards did not need a special keymap to be useful.
> We change the keymap in vendor/htc/dream/init.trout.rc, but it is
> probably the opposite of what you want.

Ok, I created something useful in the meantime. Question is, what to
do with the new keymap? I can obviously keep it at local patch, but...

PC defkeymap.map makes HTC Dream useless.

HTC Dream defkeymap.map makes PC useless :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
