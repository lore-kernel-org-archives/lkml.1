Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYESGyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYESGyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYESGxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:53:54 -0400
Received: from ms14.Sony.CO.JP ([211.125.136.233]:33354 "EHLO ms14.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbYESGxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:53:52 -0400
X-Greylist: delayed 2229 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 02:53:52 EDT
Date: Mon, 19 May 2008 15:14:40 +0900
From: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] usb-serial: pl2303: add support for RATOC REX-USB60F
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080517.001356.72708524.anemo@mba.ocn.ne.jp>
References: <20080516.171345.01918000.nemoto@toshiba-tops.co.jp> <20080517.001356.72708524.anemo@mba.ocn.ne.jp>
Message-Id: <20080519150539.0DBB.4D252088@rd.scei.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.46 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 00:13:56 +0900 (JST), 
Atsushi Nemoto <anemo@mba.ocn.ne.jp> mentioned: 
> 
> Tsukamoto-san, does your REX-USB60F work with pl2303 driver?  If so,
> we have to do some trick to support this strange device (different
> driver for same USB ID), though I'm not sure that is possible.
> Otherwise, this patch can be used to support the device correctly.

I do not think REX-USB60F will work on pl2303 driver either based on 
your lsusb info.
I saw your patch going into gregkh-2.6 tree and thank you for your fix.

I will reexamine the REX-USB60F and I will reply to you only if the 
REX-USB60F requires some trick to support different driver for same USB ID.

Thanks,

Akira

-- 
Akira Tsukamoto
Sony Computer Entertainment Inc. 
Distributed OS Development Dept. 
Japan

