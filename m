Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZBNP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZBNP7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 10:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZBNP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 10:59:31 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60800 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZBNP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 10:59:30 -0500
Subject: Re: [0/3] lenovo-sl-laptop : new driver for drivers/staging
From: Marcel Holtmann <marcel@holtmann.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexandre Rostovtsev <tetromino@gmail.com>, linux-kernel@vger.kernel.org,
       linux-laptop@vger.kernel.org
In-Reply-To: <20090214145256.GA7071@infradead.org>
References: <20090214051214.359d4fd4@leftboat.lan>
	 <20090214145256.GA7071@infradead.org>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 16:59:23 +0100
Message-Id: <1234627163.7293.196.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

> > Patches against 2.6.29-rc5 will be in following emails.
> 
> Please submit it to the kernel proper, not the staging tree.  Also
> please just submit it in one patch instead of the split.

I can only second that. This is not a driver that belongs anywhere near
the staging tree. It should be instead sent to the ACPI mailing list for
review.

The staging tree should _NOT_ be used as a shortcut for upstream
inclusion.

Regards

Marcel


