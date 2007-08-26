Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXHZQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXHZQ32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXHZQ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:29:20 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:46156 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbXHZQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:29:20 -0400
X-Greylist: delayed 1597 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 12:29:19 EDT
Message-ID: <46D1A420.8010308@datenparkplatz.de>
Date: Sun, 26 Aug 2007 18:02:40 +0200
From: Ulrich <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andreas John <lists@aj.net-lab.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com> <46CCA483.4080105@aj.net-lab.net> <46CCB23E.1000506@aj.net-lab.net> <46CD692D.3070508@aj.net-lab.net> <46D151B9.4070605@aj.net-lab.net>
In-Reply-To: <46D151B9.4070605@aj.net-lab.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


my system has an Nvidia "nForce 630A MCP" chipset.

(Asrock ALiveNF7G-HDready mainboard)


If it helps, I've uploaded the output of "lspci -vvxxx" to:

http://datenparkplatz.de/DiesUndDas/lspci-vvxxx.output.txt.


Best wishes,
Ulrich
