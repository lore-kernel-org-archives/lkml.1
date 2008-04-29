Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbYD2Olj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbYD2Olj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933032AbYD2OkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:40:15 -0400
Received: from bay0-omc2-s23.bay0.hotmail.com ([65.54.246.159]:55597 "EHLO
	bay0-omc2-s23.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933023AbYD2OkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:40:13 -0400
Message-ID: <BAY103-DAV12E9E0E5107A5FCEF3F473B2D90@phx.gbl>
X-Originating-IP: [80.204.235.254]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <BAY103-DAV11F874912A45144805FC26B2DE0@phx.gbl> <20080428.024208.153440332.davem@davemloft.net>
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Date: Tue, 29 Apr 2008 16:37:55 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 29 Apr 2008 14:40:12.0152 (UTC) FILETIME=[EE1DDF80:01C8AA06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just few minutes ago, another 2.6.25 crash
with this message:

EIP: [<c028000a>] netif_rx+0x6a/0xd0 SS:ESP 0068:c039f868

http://80.204.235.230/4.jpg


