Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZFBIKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZFBIKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZFBIKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:10:33 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:46620 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbZFBIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:10:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/10] ieee802154: add at86rf230/rf231 spi driver
Date: Tue, 2 Jun 2009 10:10:49 +0200
User-Agent: KMail/1.9.7
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com> <20090601203348.GC7143@doriath.ww600.siemens.net>
In-Reply-To: <20090601203348.GC7143@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021010.49613.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought about drivers/net as about ip (well, more or less)
> network drivers. We have drivers/atm or drivers/bluetooth (and
> bluetooth is 802.15.1...).

I actually like that this is drivers/bluetooth and not 
drivers/ieee802151. Would you consider drivers/zigbee instead of 
drivers/ieee802154 ???
