Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYDXKal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYDXKal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYDXKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:30:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43313
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbYDXKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:30:29 -0400
Date: Thu, 24 Apr 2008 03:30:29 -0700 (PDT)
Message-Id: <20080424.033029.193698693.davem@davemloft.net>
To: shigeonx@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: XTP for 2.6.25
From: David Miller <davem@davemloft.net>
In-Reply-To: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
References: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Shigeo N" <shigeonx@gmail.com>
Date: Thu, 24 Apr 2008 19:14:38 +0900

[ netdev added to CC: ]

> I implemented Xpress Transport Protocol 4.0 for Linux kernel 2.6.25.
> Does anyone test it and give me feedback to enhance together ?
> 
> I tested in the network where UDP throughput is 29Mbps, then TCP
> throughput was 13Mbps, but XTP's reached to 25Mbps.
> 
> The source is here.
> <http://downloads.sourceforge.net/linux-xtp/linux-xtp.0.3.1.tar.gz?use_mirror=osdn>
> 
> XTP specification is here.
> <http://www.packeteer.com/resources/prod-sol/XTP.pdf>
> 
> Multicast function is not implemented yet.

Please discuss your work on netdev@vger.kernel.org, which is where
the Linux networking developers are listening.

Thank you.
