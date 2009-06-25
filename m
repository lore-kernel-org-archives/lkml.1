Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZFYLmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZFYLmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZFYLme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:42:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52656 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZFYLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:42:31 -0400
Date: Thu, 25 Jun 2009 13:42:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: davidb@quicinc.com, Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       "san@android.com" <san@android.com>,
       "rlove@google.com" <rlove@google.com>, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream in 2.6.31-git? (was Re: HTC Dream aka. t-mobile g1
	support)
Message-ID: <20090625114230.GA4447@elf.ucw.cz>
References: <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com> <20090615170103.GE25040@elf.ucw.cz> <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com> <20090617091139.GA4536@elf.ucw.cz> <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com> <20090623130615.GB897@elf.ucw.cz> <20090623214543.GA22725@huya.quicinc.com> <20090624091039.GA5631@elf.ucw.cz> <d6200be20906241637q7975e623x24f2999b1cc0d3aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20906241637q7975e623x24f2999b1cc0d3aa@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 16:37:33, Arve Hj?nnev?g wrote:
> On Wed, Jun 24, 2009 at 2:10 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > On Tue 2009-06-23 14:45:43, davidb@quicinc.com wrote:
> >> On Tue, Jun 23, 2009 at 06:06:15AM -0700, Pavel Machek wrote:
> >>
> >> > Is there version of linux-msm tree for 2.6.31-git ...? (even 2.6.30 version
> >> > would help). I tried naively porting patches forward, but resulting
> >> > kernel would not boot :-(.
> >>
> >> Not yet, at least not yet in our tree.  I'm hoping to get to this
> >> fairly soon.
> >
> > If you have any patches, let me know; you'll have one happy tester.
> >
> 
> I don't have time to merge or rebase onto 2.6.31 and test it right
> now, but I pushed my old 2.6.30-rc2 test branch to
> git://android.git.kernel.org/kernel/experimental.git (as
> android-msm-2.6.30-rc2-test) which should at least get you closer to
> booting on 2.6.31.

Thanks! It actually boots for me. I'll see if I can get 2.6.30 &
2.6.31-rc to boot, too. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
