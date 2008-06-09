Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYFIQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYFIQlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYFIQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:41:05 -0400
Received: from nn7.de ([85.214.94.156]:56210 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYFIQlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:41:04 -0400
Subject: Re: 26-rc5+git hang on boot bluetooth hidd/hid_devices
From: Soeren Sonnenburg <kernel@nn7.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1213022913.17870.4.camel@violet.holtmann.net>
References: <1213015948.7018.48.camel@localhost>
	 <1213022913.17870.4.camel@violet.holtmann.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Jun 2008 18:38:29 +0200
Message-Id: <1213029509.4521.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 16:48 +0200, Marcel Holtmann wrote:
> Hi Soeren,
> 
> > updating to 2.6.26-rc5+git I recognize that debian sid suddenly hangs on
> > boot when bluetooth is activated. The last message I see is starting
> > hidd/hid_devices. And well 2.6.24/25 boot.
> > 
> > Does anybody else observe this? Any ideas?
> 
> is HID2HCI switching utility on? Do you have a HID proxy adapter in your
> system? If yes, then it is actually an USB issue.

yes hid2hci is on as this system is a macbookpro that tends to forget
that it has internal bluetooth after resume (if resume even works)

Soeren
