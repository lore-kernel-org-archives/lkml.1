Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXJQPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXJQPin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbXJQPig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:38:36 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:45965 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758574AbXJQPif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:38:35 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: 2.6.23-git11 compile issues
Date: Wed, 17 Oct 2007 18:38:52 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: lkml <linux-kernel@vger.kernel.org>
References: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710171838.52243.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wednesday 17 October 2007 Tarihinde 18:33:18 yazmıştı:
> Known issue ?
>
>
> Thanks,
> Badari
>
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from arch/x86/kernel/asm-offsets_64.c:7,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/linux/crypto.h:20:24: error: asm/atomic.h: No such file or
> directory In file included from include/linux/types.h:14,

Please try running make mrproper.

/ismail

-- 
Faith is believing what you know isn't so -- Mark Twain
