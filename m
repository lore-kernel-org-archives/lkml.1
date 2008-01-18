Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYARKb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYARKb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYARKbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:31:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbYARKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:31:21 -0500
Date: Fri, 18 Jan 2008 19:30:32 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: =?ISO-2022-JP?B?IkRhbmllbCBTcBskQmlPGyhCZyI=?= 
	<daniel.spang@gmail.com>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <cfd9edbf0801180224r3ddf1940h4245e2feff488486@mail.gmail.com>
References: <20080117120112.11CE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <cfd9edbf0801180224r3ddf1940h4245e2feff488486@mail.gmail.com>
Message-Id: <20080118192803.8FB9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 1. I doubt ZONE_DMA, please shipment ignore zone_dma patch(below).
>
> Your patch above solves the problem I had with early notification.

really!?
I am really happy!!

Thanks you.


- kosaki


