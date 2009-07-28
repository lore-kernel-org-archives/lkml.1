Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZG1QJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZG1QJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZG1QJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:09:50 -0400
Received: from relay.atmel.no ([80.232.32.139]:62732 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZG1QJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:09:50 -0400
Date: Tue, 28 Jul 2009 18:09:41 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Add poll_get_char and poll_put_char uart_ops to
 atmel_serial.
Message-ID: <20090728180941.04441c00@hskinnemoen-d830>
In-Reply-To: <20090727151900.GB4052@pc-ras4041.res.insa>
References: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com>
	<20090727162312.35c2f9d4@hskinnemoen-d830>
	<20090727151900.GB4052@pc-ras4041.res.insa>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre wrote:
> This patch allows using KGDB over the console with the atmel_serial
> driver.
> 
> Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
