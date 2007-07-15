Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbXGOKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbXGOKK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbXGOKKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:10:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434AbXGOKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:10:16 -0400
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Olaf Hering <olaf@aepfle.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0707150020s33e698d4q702018e08aeb59bc@mail.gmail.com>
References: <20070714205709.GA9478@aepfle.de>
	 <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com>
	 <20070715062708.GA11909@aepfle.de>
	 <8bd0f97a0707150020s33e698d4q702018e08aeb59bc@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 11:10:12 +0100
Message-Id: <1184494212.487.16.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 02:20 -0500, Mike Frysinger wrote:
> i honestly didnt think people would consider it for inclusion as it
> was since i ripped out a lot more headers than just asm/page.h ;)

So split it up into individual patches. It all looks good to me.

-- 
dwmw2

