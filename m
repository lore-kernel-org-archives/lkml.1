Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZFEHF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZFEHF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZFEHFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:05:18 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:27082 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbZFEHFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:05:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEtgKEpR9RkX/2dsb2JhbADPCAiEAwU
Date: Fri, 5 Jun 2009 09:05:17 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ar7_wdt: fix path to ar7 header files
Message-ID: <20090605070517.GB21360@infomag.iguana.be>
References: <200906041620.39752.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041620.39752.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While resubmitting AR7, we changed the machine specific
> headers from ar7 to mach-ar7, fix the watchdog driver
> accordingly.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

