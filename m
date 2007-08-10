Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbXHJM5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbXHJM5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbXHJM44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:56:56 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:41147 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbXHJM4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:56:55 -0400
Subject: Re: sdio: add <linux/mmc/sdio_csr.h> for CSR specific CCCR
	registers
From: Marcel Holtmann <marcel@holtmann.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
In-Reply-To: <46BC59E2.9060102@csr.com>
References: <46BC58E8.50300@csr.com>  <46BC59E2.9060102@csr.com>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 14:59:00 +0200
Message-Id: <1186750740.20129.208.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

are these CSR extensions specific to Bluetooth or do they also apply to
your WiFi and Ultra-Wideband products? If they are Bluetooth specific,
we might simply keep them inside the Bluetooth SDIO driver.

Regards

Marcel


