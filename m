Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYJ3MeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYJ3MeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYJ3MeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:34:08 -0400
Received: from mail-gx0-f30.google.com ([209.85.217.30]:34166 "EHLO
	mail-gx0-f30.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYJ3MeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=m6enmZZlHeq3apMa6HpaOQJ+7oRHsmO0nm5lFvaCvnEIV6Af7nn4rFpvrpf3oRKSnU
         OWAKhcMwf8pS9vNbPjMZ89WIanJKNqybGLUgP7gjDMuTRxoilqA24fFS02pyov6P+edw
         e/FSjw7WgtITLK6CuRt8LMW1s93adneYz9L40=
Message-ID: <b0438a630810300534jad3fec8te6555ebf9548fb8f@mail.gmail.com>
Date: Thu, 30 Oct 2008 13:34:06 +0100
From: "=?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?=" <gotzoncabanes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: SSP and SPI for IXP4XX
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I am trying to rewrite my "patches" for SSP and SPI in IXP4XX in order
to improve their style. I have a very important question I am not sure
about, so I would appreciate your comments.

The question is that I have found that the code for SSP and SPI in
PXA2XX could be reused for IXP4XX in a high percentage. I can write
the modifications, but I do not know where to place the files or if I
should rename it. Let me explain:

- Should ssp.c from arch/arm/mach-pxa2xx be placed in arch/arm/common?
- Where should ssp.h, regs-ssp.h... from
arch/arm/mach-pxa2xx/include/mach be placed?

Thanks for your attention.

Miguel Ángel Álvarez
