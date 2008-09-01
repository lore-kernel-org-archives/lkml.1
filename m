Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYIAU3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYIAU3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYIAU2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:28:51 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:36308 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYIAU2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:28:51 -0400
Message-ID: <48BC5080.2040607@free.fr>
Date: Mon, 01 Sep 2008 22:28:48 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080702 Iceape/1.1.11 (Debian-1.1.11-1)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>, next_ghost@quick.cz
Subject: Re: re : ACPI PnP on Intel MU440EX
References: <48BAD734.305@free.fr>
In-Reply-To: <48BAD734.305@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please keep CC.

> What should I do to get lspnp work with pnpacpi?

Use a newer version of lspnp.

An alternative is to do a for i in /sys/bus/pnp/devices/*; do echo $i; 
cat $i/*; done

Matthieu

