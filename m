Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYLIQOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYLIQOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYLIQOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:14:31 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:31492 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbYLIQOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:14:30 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAHImPklXQHK3/2dsb2JhbACBbM9Wgwc
Date: Tue, 9 Dec 2008 17:14:25 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: New library code
Message-ID: <20081209161425.GE32662@infomag.infomag.iguana.be>
References: <20081204155250.59a1d30c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204155250.59a1d30c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

The flue changed my weekend :-(. I do however have 2 general questions first:

> - Handles the temperature device
Why don't we treat the temperature part not as a hwmon?

> - It does all the reboot, nowayout and module locking and housekeeping
Why don't we use the shutdown methods of our platform and other devices instead of the reboot notifier setup?

Kind regards,
Wim.

