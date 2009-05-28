Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZE1Jvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZE1Jvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZE1Jv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:51:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34333 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZE1Jv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:51:28 -0400
X-Auth-Info: AXiptBCCJmn2QUrZucSQjEuUxEehi5B9jU0bv0NvyMQ=
To: Grant Likely <grant.likely@secretlab.ca>
cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <fa686aa40905272029n32aa5f1ds86d07f0de4894815@mail.gmail.com>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de> <fa686aa40905272029n32aa5f1ds86d07f0de4894815@mail.gmail.com>
Comments: In-reply-to Grant Likely <grant.likely@secretlab.ca>
   message dated "Wed, 27 May 2009 21:29:26 -0600."
Date: Thu, 28 May 2009 11:51:26 +0200
Message-Id: <20090528095126.99DB4832E416@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Grant Likely,

In message <fa686aa40905272029n32aa5f1ds86d07f0de4894815@mail.gmail.com> you wrote:
>
> Personally, I attribute a lot of that in powerpc land to the fact that
> we had no clue what we were doing when we started the process of
> porting all powerpc platforms to use the device tree.  It was hard.
> It was painful.  We didn't have much established convention to learn
> from.  However, now that it is complete I would say that it has been a
> net-win and it is now simpler to bring up new boards and SoCs than it
> ever was before.

True. From a commercial point of view this is a huge  problem  casued
by the device tree - custumers who used to oder a BSP from commercial
service providers (like Robert or me :-) now often find that all they
need  to  do is to tweak the device tree to get their system running.
Lost business. D*mn...  [Maybe this explains Robert's reluctance?]

But as stated before:  from the engineering point of view it's a real
big win now.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Ever try. Ever fail. No matter. Try again. Fail again.  Fail  better.
                                                        -- S. Beckett
