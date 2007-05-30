Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbXE3OwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbXE3OwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXE3OwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:52:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:37660 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751894AbXE3OwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:52:10 -0400
Date: Wed, 30 May 2007 16:56:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <200705210016.20794.dtor@insightbb.com>  <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
  <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com> 
 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Renato Golin wrote:

> But it's pathetic the fact that ubuntu's kernel have an option USB_DEBUG 
> I did it and monitored mesasges and syslog and both shows the same 
> data... I guess that dump after mouse detection is DEBUG_DATA in place.

Hi Renato,

do any data appear in the kernel log when you generate events with the 
device (i.e. move the joystick, press the buttons, etc)? That should be 
reported if DEBUG_DATA is defined properly on the older kernels.

Thanks,

-- 
Jiri Kosina
