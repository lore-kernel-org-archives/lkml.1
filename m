Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbXIRSmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbXIRSmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXIRSlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:41:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35763 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbXIRSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:41:50 -0400
Message-ID: <46F01BDE.6020902@zytor.com>
Date: Tue, 18 Sep 2007 11:41:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mchan@broadcom.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
References: <200709181823.26429.vda.linux@googlemail.com>	<1190141114.9540.216.camel@dell> <20070918.112337.74737433.davem@davemloft.net>
In-Reply-To: <20070918.112337.74737433.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> 
> I don't like it because it means people have to setup full initrd's
> in order to do network booting with such network cards.
> 

klibc could help with that, if there is interest in exploring that
avenue again.

	-hpa
