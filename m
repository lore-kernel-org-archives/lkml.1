Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXEWOq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXEWOq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbXEWOqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:46:52 -0400
Received: from twin.jikos.cz ([213.151.79.26]:49619 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbXEWOqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:46:51 -0400
Date: Wed, 23 May 2007 16:46:42 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Renato Golin <rengolin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] joydev.c automatic re-calibration
In-Reply-To: <d120d5000705230737s40d92df7m91a7b574e3a9c0d1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705231644520.27422@twin.jikos.cz>
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com> 
 <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
 <d120d5000705230737s40d92df7m91a7b574e3a9c0d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Dmitry Torokhov wrote:

> > Also, if you'd like to get your patch merged, you should add proper 
> > Signed-off-by line.
> So did you come to the conclusion that HID can't set up true (or real)
> range for some of Saitek's axes upon input device registration?

I have asked Renato to provide HID debugging output a few days ago - see 
http://lkml.org/lkml/2007/5/21/201 - but that was without reply.

Renato, do you think you could try this, so that we can understand better 
if we can't put a HID quirk to normalize the values on HID-level somehow?

Thanks a lot,

-- 
Jiri Kosina
