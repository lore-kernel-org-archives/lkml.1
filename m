Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYENMfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYENMfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761291AbYENMex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:34:53 -0400
Received: from bay0-omc2-s10.bay0.hotmail.com ([65.54.246.146]:8319 "EHLO
	bay0-omc2-s10.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759007AbYENMev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:34:51 -0400
Message-ID: <BAY103-DAV93FF6F8B9D646F584F69CB2CE0@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <BAY103-DAV122A113843FE9574256A0AB2D60@phx.gbl> <BAY103-DAV6446AEC1CBB678E5D0E52B2D30@phx.gbl> <20080509102509.GA11710@gondor.apana.org.au> <BAY103-DAV5B5CD83FC6A95A5DD48C9B2CC0@phx.gbl> <20080512074642.GA1416@gondor.apana.org.au> <BAY103-DAV521435E26209347B7646FB2CC0@phx.gbl> <BAY103-DAV2A04E519F35401C98403FB2CC0@phx.gbl> <BAY103-DAV20B0EEFFB30A41A8020C8B2CC0@phx.gbl> <BAY103-DAV88950FC99CDE9EAAE27B2B2CE0@phx.gbl> <BAY103-DAV745BB1E190B27DAD19A19B2CE0@phx.gbl> <20080514122100.GA22726@gondor.apana.org.au>
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Date: Wed, 14 May 2008 14:32:18 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 14 May 2008 12:34:50.0437 (UTC) FILETIME=[E7057F50:01C8B5BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:

> This patch should let you test that kernel:

yes it works. Thanks.


