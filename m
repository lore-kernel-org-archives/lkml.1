Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbZLKLlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbZLKLlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762489AbZLKLlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:41:06 -0500
Received: from smtp.nokia.com ([192.100.105.134]:63405 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762388AbZLKLkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:40:53 -0500
Date: Fri, 11 Dec 2009 13:40:15 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC/PATCH 5/5] usb: musb: musb supports otg notifier
Message-ID: <20091211114015.GC12526@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <1260531086-23857-6-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1260531086-23857-6-git-send-email-felipe.balbi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Dec 2009 11:40:28.0238 (UTC) FILETIME=[BC896EE0:01CA7A56]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:31:26PM +0100, Balbi Felipe (Nokia-D/Helsinki) wrote:
>we use the notifier to kick the charger detection.
>Needed on RX-51 board. Later on we will notify
>also the bMaxPower field from usb_configuration.
>
>Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

this is supposed to be:
NYET-Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

-- 
balbi
