Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZFRUAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZFRUAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZFRUA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:00:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30532 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZFRUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SXVuH4BUQpSLM6to3n/4214Uojb70I57GxsXp6TbvaMSUx2ghnYHXVVohMuGMs9TQH
         5BcC6MdyTKEAt9l+VKEW5PXYu9u3zUQOcMp8INljZFHDlwkQfGm6Ki29ma5IWrOTAShw
         +pwHJ1xHGRX/h0UPrN8VGbTpl3jfdWccvAckk=
MIME-Version: 1.0
In-Reply-To: <cd73a99e0906181258v51372258n5fd134be9605cb11@mail.gmail.com>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
	 <1245200079-6323-2-git-send-email-rob@emanuele.us>
	 <cd73a99e0906181258v51372258n5fd134be9605cb11@mail.gmail.com>
Date: Thu, 18 Jun 2009 22:00:30 +0200
Message-ID: <cd73a99e0906181300x5c0dfe73n741c28a7e550b37b@mail.gmail.com>
Subject: Re: [PATCH 2/6] atmel-mci: Platform configuration to the the 
	atmel-mci driver
From: Andrew Victor <avictor.za@gmail.com>
To: Rob Emanuele <rob@emanuele.us>
Cc: nicolas.ferre@atmel.com, haavard.skinnemoen@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current at91_mci also allows the driver to control the "vcc_pin".
> Can that functionality be merged into atmel_mci driver?

Ignore that comment, I see it's in Patch 5.
