Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZCLMux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZCLMux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZCLMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:50:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:47898 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZCLMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RAAp5lnIgA7IRwFBVzFklkQ6LySIZSOFIwnJOVla+m8220/0dC4tF7pdDqRY5Oz0YQ
         XZz5tPP1UnzAkSsKOFaTtNGOHIDAeht0z1igiopvngDh9z0d5NiJ1uF1La3k0Yrt9alz
         MfDMKfAvapvcCfA6HaZc0Zy+x9F4hi/SPR82s=
Subject: Re: [PATCH 1/7] mmc_spi: allow setting of spi mode 3
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Wolfgang =?ISO-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200903111413.15981.wolfgang.mues@auerswald.de>
References: <200903111413.15981.wolfgang.mues@auerswald.de>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 14:50:32 +0200
Message-Id: <1236862232.12514.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small question:

Do linux SDHCI driver support SD 4 wire mode?

Or it uses the SPI mode.


Best regards,
	Maxim Levitsky

