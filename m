Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZICSHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZICSHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZICSHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:07:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZICSHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:07:36 -0400
From: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Frans Pop <elendil@planet.nl>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Thu, 3 Sep 2009 20:07:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909030042.45081.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl>
In-Reply-To: <200909031927.19590.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909032007.18484.christian@kraemer-eu.de>
X-Provags-ID: V01U2FsdGVkX18tC1pp57KL86PhGmyIgQVH3ZbniRQZkS6UWQN
 A3Lg5S+vvKVEHwpB/ZPp29h5dWLfH1wO9IyL/ZrEbXe2VTL+bt
 kQBgDMb7njFva3W6y6PxmxCwNY5NP9Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 19:27:18 Frans Pop wrote:
> Christian: what is the PCI ID of the device? You can find out using
> 'lspci -H1 -nn'.

The device class is 0200 and the PCI ID is 168c:0013.

Here is the line lspci -H1 -nn shows for the card:
01:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor [168c:0013] (rev 01)
