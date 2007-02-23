Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXBWTsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXBWTsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbXBWTsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:48:35 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:32694 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbXBWTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eJt79eCvGWgIzXzf1ljqhIL8ZwCh3mHuTQ9hvM7uNMHFlvGnY2ovzKgEEHPIsNlSFmUXql5w4NqYZoAv7RNz9Iqjp8IcTLwwEQoqoxtSlp1vA4ZSCC0pKek8jU1+3ZDsVOq4eBsQBRuLwbc5bCn6jJqDtyCp0mGJVKXXxBAuyCw=
Message-ID: <8d158e1f0702231148t21c34b3j3468d8bafb63b42@mail.gmail.com>
Date: Fri, 23 Feb 2007 20:48:29 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [UMTS/HSDPA] Kernel module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All!

For my work I am using a Huawei E620 HSDPA/UMTS card, and I would like
to use it under Linux :)

Before this I had a card with only UMTS/GPRS functions and as soon as
I inserted the card some /dev/ttyUSB nodes were created, with this
card this doesnt happen, eventho the different fora say it should.

On one of the fora I see that an external module exists for this card,
but when I try to compile it it tells me TTY_DONT_FLIP is not defined.

This sounds like something that should be (or used to be) defined by
tty_driver.h or tty_flip.h.

Does anyone have an idea of how to use this card or compile these
drivers needing the TTY_DONT_FLIP?


Thanks,


Patrick
