Return-Path: <linux-kernel-owner+w=401wt.eu-S1764432AbXKOMe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764432AbXKOMe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXKOMeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:34:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63353 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753762AbXKOMeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:34:18 -0500
Date: Thu, 15 Nov 2007 13:33:52 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH] More CFI fixups for Atmel chips
Message-ID: <20071115133352.4bf0bba2@dhcp-255-175.norway.atmel.com>
In-Reply-To: <1193758387-9325-1-git-send-email-hskinnemoen@atmel.com>
References: <1193758387-9325-1-git-send-email-hskinnemoen@atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 16:33:07 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> This patch (or some variation of it) has been posted a couple of times
> before to the MTD list, and I find myself applying it over and over
> again when testing stuff against the latest mainline tree. I'd
> appreciate if you could either apply it or thoroughly NAK it, as MTD
> on the ATNGW100 board is currently broken.

Ok, can I just get a quick ACK or NAK then? I'd really like to get this
fixed in mainline. It's causing real data corruption problems on real
boards that are otherwise nicely supported in mainline.

Håvard
