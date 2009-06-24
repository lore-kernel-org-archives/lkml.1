Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZFXXhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZFXXhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZFXXhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:37:33 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:39646 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZFXXhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <20090624091039.GA5631@elf.ucw.cz>
References: <20090611082532.GE8592@elf.ucw.cz>
	 <20090612150504.GA15084@elf.ucw.cz>
	 <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
	 <20090615170103.GE25040@elf.ucw.cz>
	 <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com>
	 <20090617091139.GA4536@elf.ucw.cz>
	 <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com>
	 <20090623130615.GB897@elf.ucw.cz>
	 <20090623214543.GA22725@huya.quicinc.com>
	 <20090624091039.GA5631@elf.ucw.cz>
Date: Wed, 24 Jun 2009 16:37:33 -0700
Message-ID: <d6200be20906241637q7975e623x24f2999b1cc0d3aa@mail.gmail.com>
Subject: Re: HTC Dream in 2.6.31-git? (was Re: HTC Dream aka. t-mobile g1 
	support)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: davidb@quicinc.com, Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       "san@android.com" <san@android.com>,
       "rlove@google.com" <rlove@google.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 2:10 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Tue 2009-06-23 14:45:43, davidb@quicinc.com wrote:
>> On Tue, Jun 23, 2009 at 06:06:15AM -0700, Pavel Machek wrote:
>>
>> > Is there version of linux-msm tree for 2.6.31-git ...? (even 2.6.30 version
>> > would help). I tried naively porting patches forward, but resulting
>> > kernel would not boot :-(.
>>
>> Not yet, at least not yet in our tree.  I'm hoping to get to this
>> fairly soon.
>
> If you have any patches, let me know; you'll have one happy tester.
>

I don't have time to merge or rebase onto 2.6.31 and test it right
now, but I pushed my old 2.6.30-rc2 test branch to
git://android.git.kernel.org/kernel/experimental.git (as
android-msm-2.6.30-rc2-test) which should at least get you closer to
booting on 2.6.31.

-- 
Arve Hjønnevåg
