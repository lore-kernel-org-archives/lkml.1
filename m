Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZLDO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZLDO6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZLDO6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:58:16 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41227 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbZLDO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=EPZPEzkB3o795LYQpfs0BZ8eseFgujXpogQsUkaR4qMrd/bEtEefCSI0xHQhxhnk6L
         BH9+puMokwGSVY4xWDSXyjDZ8Lx4HctoDeqFK81RKTGe937pJcEuAS7PCgD6LsPqSH4X
         NmFGe58TaFcndi9J4UwgjjlxZ7gigOXbuASAY=
Subject: Re: [PATCH v7 8/8] Loongson: YeeLoong: add input/hotkey driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <20091204081402.GD1540@ucw.cz>
References: <cover.1259932036.git.wuzhangjin@gmail.com>
	 <7e96d37889c49c2d6d284e21773aef90dd3aac25.1259932036.git.wuzhangjin@gmail.com>
	 <20091204081402.GD1540@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 04 Dec 2009 22:57:52 +0800
Message-ID: <1259938672.9554.3.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 09:14 +0100, Pavel Machek wrote:
> Hi!
> 
> 
> > +#define NO_REG		0
> > +#define NO_HANDLER	NULL
> 
> Don't obfuscate code like that.

Will remove it later, thanks!


