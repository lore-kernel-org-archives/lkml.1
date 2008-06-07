Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbYFGPl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbYFGPl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYFGPlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:41:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:23429 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbYFGPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m8S0qbxScA9LseCQxT7EP9SIteU+b2xtwjm3F2Ee0GA1PxDVm3tvbA1w01jbdyJQsr
         z3j8RpEgoljCQl/KrwT2e4hZOWGh5/fSMT8R+gNOWbzdKktEKhgaGZerHqOVttAsaPUq
         Oc3JS2mX72wioLU2kLysA/DKr4UPTuqUToMfA=
Message-ID: <cd73a99e0806070841m22f2364dy916e7b1c6f2cdeda@mail.gmail.com>
Date: Sat, 7 Jun 2008 17:41:21 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/8] at91_nand: Convert to generic GPIO API
Cc: linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> No point in using an AT91-specific GPIO API when the generic API works
> just as well.

Driver existed before there was a generic GPIO API.  :)


> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
