Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYJJLYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYJJLYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYJJLYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:24:21 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:49816 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYJJLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oaOGHCIQbHAEHQt7MPn0WcNxfOR1Corfh4DvOe10+6v8uNpo+RTbna5+QkZGeZr96R
         9dPP0ajgfrQ4COFiY3nnFFkDg5Gx8bmmkLEgUzOWsEEf0fG/zCuI5IH59vSLTiadRgWV
         YNFCrtzN3eix92HCYLCBh81pAVqnTSoQJDLwE=
Message-ID: <80b317760810100424t263ef059t3f0e94e3eaa5ffc7@mail.gmail.com>
Date: Fri, 10 Oct 2008 13:24:19 +0200
From: "Richard Genoud" <richard.genoud@gmail.com>
To: "Uros Bizjak" <ubizjak@gmail.com>
Subject: Re: [PATCH, arm] CompactFlash card driver for AT91SAM9260
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5787cf470810100319x5f52be24w1dba5b3c91231945@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5787cf470810100057m1e841103hf183c0e5462579b4@mail.gmail.com>
	 <5787cf470810100319x5f52be24w1dba5b3c91231945@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/10 Uros Bizjak <ubizjak@gmail.com>:
> Hello!
>
> Attached patch implements driver for CF card on AT91SAM9260.The patch
> supportsMemory & IO mode hardware configuration, as shown in section
> 20.7.6.1 of AT91SAM9260 hardware manual. CF timings are based on
> Common Memory Read/Write Timing Specification of "CF+ and CompactFlash
> Specification Revision 2.0", the implementation includes TDF
> optimization of SMC.

hi !
I think that you should post your patch to the linux-arm-kernel ML,
and CC Andrew Victor ( linux@maxim.org.za ).

regards.
