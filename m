Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbXCNTMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbXCNTMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXCNTMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:12:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21388 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbXCNTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NMltC6gKrtzqylPqiSzcqHscI6+VdddV3i9n+wRMIicNV35tIPk91SNTasIRL7zH87u5SypGgP9LL8FIAdX5hCXnAIg/OU1UFlTH2DlgKDD0qYp4/EAtW0CtHK+JU6ADYCatqhLk2fHi+rIQHxnhrhdTh59EdfsOv920KRpDRnI=
Message-ID: <8e4ff20a0703141212k4534f425s72ed4497507ef76@mail.gmail.com>
Date: Wed, 14 Mar 2007 20:12:35 +0100
From: "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>
To: "Anssi Hannula" <anssi.hannula@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "johann deneux" <johann.deneux@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <45EEEAA3.50009@gmail.com>
	 <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>
	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 On 3/14/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
 >  >> Do we have any idea if there any users of FF out there?
 > >
 > > At least me :). I'm using it for wheel and joystick in modules for locally
 > > developped multiplatform virtual reality system.
 >
 >  Wine and BZflag come to mind, though I think the support is quite
 > limited in both.
 >

There's also vDrift (racing sim), they added support very recently.
I plan to add it in my car sim too, but there's still nothing coded.

I have a question: if the force is to be 3D, why only 3 possible
values? What would they be, 3 torques or 3 forces? In the case of car
sims (ff steering wheels), only one axis of torque is usually used
(except for 6 dof platforms, as mentioned).

By the way, is this the correct list for asking trivial questions
(such as questions about how the ff api works), or is it only for
development of kernel?

(hope the mail arrives this time; the first one was apparently sent as
html, which is considered spam by the mailing list; and the
notification about that problem was considered spam by gmail too!)

-- 
Saludos,
     STenyaK

_______________________________________________
Site:   http://1ksurvivor.homeip.net  <1kSurvivor>
         http://motorsport-sim.org     <Motorsport>
         http://kwh.iespana.es         <KuantikalWareHouse>
         http://emuletutorial.info     <EmuleTutorial>
ICQ:    153709484
Mail:   stenyak AT gmail DOT com
