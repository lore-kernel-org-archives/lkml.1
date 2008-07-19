Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYGSV4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYGSV4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYGSV4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:56:43 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50879 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbYGSV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:56:43 -0400
Date: Sat, 19 Jul 2008 23:56:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: david@lang.hm
cc: Craig Milo Rogers <rogers@ISI.EDU>, Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <alpine.DEB.1.10.0807191354240.6370@asgard>
Message-ID: <alpine.LNX.1.10.0807192350020.21244@fbirervta.pbzchgretzou.qr>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
 <alpine.LNX.1.10.0807150851040.13215@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807171920010.12734@fbirervta.pbzchgretzou.qr> <20080717195625.GC6777@isi.edu> <alpine.LNX.1.10.0807172221130.12734@fbirervta.pbzchgretzou.qr> <20080719080002.GA11272@isi.edu>
 <4881AB31.7010400@keyaccess.nl> <20080719204933.GE18350@isi.edu> <alpine.DEB.1.10.0807191354240.6370@asgard>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-07-19 22:56, david@lang.hm wrote:
> On Sat, 19 Jul 2008, Craig Milo Rogers wrote:
>> On 08.07.19, Rene Herman wrote:
>>
>>> Really, find me a single Linux developer who wouldn't try just a
>>> little bit harder for a big 3.0 release. This is still a
>>> community, not yet a boring office schedule...
>>
>> 	I'm afraid that the allure of 3.0 would mean that everyone
>> would want to get their shiny new subsystem/scheduler
>> rewrite/bootstrap file format change/whatever incorporated into it

Which is why it should not be announced early, but happen
spontaenously at Linus's discretion, right after the last -rc.

>> it, resulting in a protracted integration period and an unstable
>> system. According to this line of thought, Linus should simply
>> announce version 3.0 with no forewarning...
>
> not to mention that people would avoid it becouse it would be a .0
> release and therefor perceived as being unstable (and for the
> reasons that Craig lists, they would probably be right)

Maybe we should also start skipping on numbers like 2.x.4, 2.x.13,
and 2.6.66.
"What's in a number?"
Maybe we should only ever release 2.<odd>.0 to show that there is 
nothing bad about being an <odd> or a .0 release.
