Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZAHMxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZAHMxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZAHMxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:53:13 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:34226 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbZAHMxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:53:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQFAEeFZUlR9dV2/2dsb2JhbACBa8xVhXU
Date: Thu, 8 Jan 2009 13:53:10 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29] [WATCHDOG] wm8350: Fix section annotations
Message-ID: <20090108125310.GJ11454@infomag.infomag.iguana.be>
References: <1231416267-3026-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231416267-3026-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> The probe and remove functions were incorrectly annotated, with the
> misannotation of the remove function causing build failures when built
> in.

I'll add it to the linux-2.6-watchdog-next tree tonight.
I'll probably sent it in for mainline inclusion this weekend.

Kind regards,
Wim.

