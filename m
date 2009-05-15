Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZEOOPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZEOOPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZEOOPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:15:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42924 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZEOOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:15:31 -0400
Subject: Re: [PATCH/RESEND 2.6.29.3] MTD: Add SST39SF040 chip to jedec_probe
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090512223718.GB26588@rere.qmqm.pl>
References: <20081118010902.GA4130@rere.qmqm.pl>
	 <20090512223718.GB26588@rere.qmqm.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 May 2009 17:15:08 +0300
Message-Id: <1242396908.27996.253.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 May 2009 14:15:09.0738 (UTC) FILETIME=[8DFE70A0:01C9D567]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 00:37 +0200, Michał Mirosław wrote:
> Add SST39SF040 chip (like SST39SF020A but bigger - 4Mbit).
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>

Taken to l2-mtd-2.6.git.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

