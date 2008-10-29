Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYJ2VDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYJ2VDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYJ2VDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:03:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:3016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYJ2VDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hs9101AA/8iszHkHjgYLEs1lkcS0exrTAjQ/G6MBCOhZ/lTqCfKsANgds6uXQIxgcd
         0+hh25IDS2PWymtxhmwilHHdgQN03E/gmbk4nW830V4DbCORIH1/rp55jXCydmkjVvs/
         y479e7hpknDka3cQAoF3rOm6AirhSmKH24CR0=
Message-ID: <90edad820810291402q3a9bbf41i45401867c28535fb@mail.gmail.com>
Date: Wed, 29 Oct 2008 23:02:56 +0200
From: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [PATCH] CHAR: Delete old and now unused M48T35 RTC driver for SGI IP27.
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       "Dmitri Vorobiev" <dmitri.vorobiev@movial.fi>
In-Reply-To: <1225113552-15376-2-git-send-email-ralf@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90edad820810270453s57954112m627859eac685f404@mail.gmail.com>
	 <1225113552-15376-2-git-send-email-ralf@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/27 Ralf Baechle <ralf@linux-mips.org>:
> It was only used by this one SGI platform which recently was converted to
> RTC_LIB and with RTC_LIB enabled the legacy drivers are no more selectable.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
