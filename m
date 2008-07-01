Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbYGAQRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbYGAQRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbYGAQR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:17:27 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:53662 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbYGAQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:17:26 -0400
Message-Id: <200807011617.m61GHF7c005071@cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM driver to request_firmware()
In-reply-to: <1214917573.10393.391.camel@pmac.infradead.org>
Date: Tue, 01 Jul 2008 12:17:15 -0400
X-NRLCMF-Spam-Score: () hits=-0.019
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1214917573.10393.391.camel@pmac.infradead.org>,David Woodhouse writ
es:
>Perhaps so. But in that case why do we bother with MODULE_FIRMWARE at
>all? :)

dogged consistency or perhaps a shining beacon of correctness. :)
