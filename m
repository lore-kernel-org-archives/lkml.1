Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYJTVAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYJTVAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYJTVAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:00:37 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:56842 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbYJTVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:00:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAAON/EhR92Ji/2dsb2JhbACBcsFmg2w
Date: Mon, 20 Oct 2008 23:00:34 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add support for the WM8350 watchdog
Message-ID: <20081020210034.GL30246@infomag.infomag.iguana.be>
References: <1224529931-9860-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224529931-9860-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> This driver implements support for the watchdog functionality provided
> by the Wolfson Microelectronics WM8350, a multi-function audio and
> power management subsystem intended for use in embedded systems. It is
> based on a driver originally written by Graeme Gregory, though it has
> been extensively modified since then.
> 
> Use of a GPIO to kick the watchdog is not yet supported.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Reviewing this one. Will get back on this driver tomorrow.

Kind regards,
Wim.

