Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbXGBR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbXGBR21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXGBR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:28:21 -0400
Received: from vz5201.evanzo-server.de ([62.67.245.201]:34944 "EHLO
	vz5201.evanzo-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbXGBR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:28:20 -0400
Message-ID: <468935AD.8030402@boneko.de>
Date: Mon, 02 Jul 2007 19:28:13 +0200
From: Tim Boneko <tim@boneko.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Old bug in tg3 driver unfixed?
References: <46864736.3090108@boneko.de> <46893264.8050908@tmr.com>
In-Reply-To: <46893264.8050908@tmr.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list & Bill,

Bill Davidsen wrote:

> Probably unrelated, but what's eth0?

An additional pci NIC. The second Broadcom NIC of the mainboard doesn't
even show up in lspci, no matter how the relevant jumper on the board is
set.

	timbo
