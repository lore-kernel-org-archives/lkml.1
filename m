Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbZFQVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbZFQVgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZFQVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:36:48 -0400
Received: from mail-qy0-f201.google.com ([209.85.221.201]:40329 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZFQVgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com>
References: <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
	 <20090611082532.GE8592@elf.ucw.cz>
	 <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
	 <20090612150504.GA15084@elf.ucw.cz>
	 <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
	 <20090615170103.GE25040@elf.ucw.cz>
	 <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com>
	 <20090617091139.GA4536@elf.ucw.cz>
	 <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com>
Date: Wed, 17 Jun 2009 14:36:50 -0700
Message-ID: <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 2:40 AM, Brian Swetland<swetland@google.com> wrote:
> On Wed, Jun 17, 2009 at 2:11 AM, Pavel Machek<pavel@ucw.cz> wrote:
...
>> One more question... do you have keymap.map to make console usable? By
>> default, keyboard lacks any special characters...
>
> I don't think we ever put together a full keymap for the console,
> since we don't use it much.  Arve might have done something with
> setkey once upon a time.
>

I used setkey on older hardware to get a usable console, but the
original dream keyboards did not need a special keymap to be useful.
We change the keymap in vendor/htc/dream/init.trout.rc, but it is
probably the opposite of what you want.

-- 
Arve Hjønnevåg
