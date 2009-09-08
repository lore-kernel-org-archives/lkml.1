Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZIHIaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZIHIaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZIHIaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:30:07 -0400
Received: from relay.atmel.no ([80.232.32.139]:64407 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZIHIaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:30:06 -0400
Date: Tue, 8 Sep 2009 10:30:03 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH v2] Add poll_get_char and poll_put_char uart_ops to
 atmel_serial.
Message-ID: <20090908103003.7617ff58@hskinnemoen-d830>
In-Reply-To: <1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
	<1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
> This patch allows using KGDB over the console with the atmel_serial
> driver.
> 
> Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
