Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYE2VC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYE2VC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYE2VCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:02:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYE2VCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:02:44 -0400
Subject: Re: [PATCH] smctr: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: maximilian attems <max@stro.at>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080529193047.GB2129@stro.at>
References: <20080529193047.GB2129@stro.at>
Content-Type: text/plain
Date: Fri, 30 May 2008 00:02:34 +0300
Message-Id: <1212094954.18530.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 21:30 +0200, maximilian attems wrote:
> 
> thanks a lot, please add a printk for users:
>         printk(KERN_ERR "smctr: Can't load firmware file tr_smctr.bin\n")

I think you get that kind of failure report from udev anyway, don't you?
You certainly get the 'trying to load...' from the kernel.

-- 
dwmw2

