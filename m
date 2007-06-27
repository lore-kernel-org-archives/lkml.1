Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbXF0Tq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbXF0Tq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763173AbXF0TpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:45:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39910 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762683AbXF0TpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:45:16 -0400
Date: Wed, 27 Jun 2007 21:45:13 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Antonino Ingargiola <tritemio@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Possible BUG] Logitech USB keyboard inconsistent led state
In-Reply-To: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706272144280.9610@twin.jikos.cz>
References: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Antonino Ingargiola wrote:

> I'm using a logitech USB keyboard, I think it's one of the most cheap 
> and diffuse logitech keyboard models.
> I have an inconsistent led state. During boot the NumLock led blinks 
> several times and is on as boot finishes. However the numeric keypad 
> works as it was off (no numbers, keypad '.' works as Canc, '0' as Ins 
> and so on).

Could you please send me vendor and product ids of the keyboard? I will 
send you a patch to test.

Thanks,

-- 
Jiri Kosina
