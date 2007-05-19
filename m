Return-Path: <linux-kernel-owner+w=401wt.eu-S1764820AbXESWPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764820AbXESWPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbXESWO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:14:57 -0400
Received: from neon.samage.net ([85.17.153.66]:45965 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025AbXESWO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:14:56 -0400
Message-ID: <4376.81.207.0.53.1179612894.squirrel@secure.samage.net>
In-Reply-To: <464F74C4.5070404@googlemail.com>
References: <464F6DC9.80805@googlemail.com>
    <464F74C4.5070404@googlemail.com>
Date: Sun, 20 May 2007 00:14:54 +0200 (CEST)
Subject: Re: [2/5] 2.6.22-rc2: known regressions
From: "Indan Zupancic" <indan@nul.nu>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       "Uwe Bugla" <uwe.bugla@gmx.de>, xfs-masters@oss.sgi.com,
       "David Chinner" <dgc@sgi.com>,
       "Maurice van der Pot" <griffon26@kfk4ever.com>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Dave Airlie" <airlied@linux.ie>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 964c6a2bc69af72888bec91466701c23
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 00:05, Michal Piotrowski wrote:
> Hi all,
>
> Here is a list of some known regressions in 2.6.22-rc2.
>
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions

> Subject    : SLAB doesn't like usb_get_configuration()
> References : http://lkml.org/lkml/2007/5/19/96
> Submitter  : Indan Zupancic <indan@nul.nu>
> Status     : Unknown

This one is fixed: http://lkml.org/lkml/2007/5/19/171

Regards,

Indan


