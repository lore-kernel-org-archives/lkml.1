Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZLHHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZLHHS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZLHHSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:18:25 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:43714 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZLHHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:18:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Jkum7aRvZyzYxxlsf6l4dshJgDuBx2uo4ryvGCwWNpbXOsgSPRwl4GtoKjhgjH0XHt
         cmrP/YNJdbM1YElSC2HQ6aqh+6XQT9t3Wm19khOIf+h12NIM1Mo1wZj2O+GBpjYUACoE
         r8tbm683ooI70+WbmngqAzoxZIFyb1qAA8VRI=
Subject: Re: [PATCH v8 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091208070643.GB12264@elf.ucw.cz>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <d8789fa7e97d8a170c4e2516d7ef2d2fbbe42cc6.1260082252.git.wuzhangjin@gmail.com>
	 <20091206084717.GD2766@ucw.cz> <1260147298.3126.2.camel@falcon.domain.org>
	 <20091207080446.GB23088@elf.ucw.cz>
	 <1260178870.9092.34.camel@falcon.domain.org>
	 <20091207094909.GD23088@elf.ucw.cz>
	 <1260255056.3315.23.camel@falcon.domain.org>
	 <20091208070643.GB12264@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 08 Dec 2009 15:18:01 +0800
Message-ID: <1260256681.3315.54.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 08:06 +0100, Pavel Machek wrote:
> On Tue 2009-12-08 14:50:56, Wu Zhangjin wrote:
> > Hi, Pavel Machek
> > 
> > After fixing the get_battery_current(), can I get your Acked-by: for the
> > next revision of this patch?
> 
> Yes... you can add my ack for 4-6/8.

Thanks, will add your ack and resend the patchset later ;)

Regards,
	Wu Zhangjin

