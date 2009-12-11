Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZLKMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZLKMfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZLKMfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:35:48 -0500
Received: from smtp.nokia.com ([192.100.105.134]:19290 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZLKMfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:35:47 -0500
Message-ID: <4B223C78.2060908@nokia.com>
Date: Fri, 11 Dec 2009 14:35:04 +0200
From: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC/PATCH 4/5] usb: musb: isp1704: add registers from isp1704
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <1260531086-23857-5-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1260531086-23857-5-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2009 12:35:10.0082 (UTC) FILETIME=[60AB1620:01CA7A5E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbi Felipe (Nokia-D/Helsinki) wrote:
> transceiver used on RX-51 board.
>
> NYET-Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
>   

There are now many ULPI transceivers in use. Let's add the global ULPI 
register definitions. isp170x transceivers have only one vendor-specific 
register. The Power Control.

-- 
heikki

