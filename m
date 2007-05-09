Return-Path: <linux-kernel-owner+w=401wt.eu-S968585AbXEIE3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968585AbXEIE3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 00:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935008AbXEIE3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 00:29:38 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:48460 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941AbXEIE3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 00:29:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuE6ADXqQEZKhRO4W2dsb2JhbACBXI4VHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jan Kratochvil <honza@jikos.cz>
Subject: Re: [PATCH 3/3] xpad.c: Added Xbox360 gamepad rumble support.
Date: Wed, 9 May 2007 00:29:35 -0400
User-Agent: KMail/1.9.3
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
References: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz> <alpine.LRH.0.98.0705031504280.22353@twin.jikos.cz>
In-Reply-To: <alpine.LRH.0.98.0705031504280.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705090029.35979.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007 09:04, Jan Kratochvil wrote:
> Hi Dmitry,
>    thanks for feedback. Improved version of this patch follows:
> 
> It is enabled only if CONFIG_XPAD_FF is set to y.
> 
> Implementation is using force feedback support for memoryless devices.

Applied with couple cosmetic changes, thank you.

-- 
Dmitry
