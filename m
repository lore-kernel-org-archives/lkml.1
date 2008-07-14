Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYGNN7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYGNN7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYGNN7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:59:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYGNN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:59:11 -0400
Subject: Re: [PATCH] qla1280: use request_firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Jes Sorensen <jes@sgi.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <487B1C73.5000202@sgi.com>
References: <1215770284.2733.10.camel@jaswinder.satnam>
	 <487B1C73.5000202@sgi.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 06:59:03 -0700
Message-Id: <1216043943.27455.14.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 11:29 +0200, Jes Sorensen wrote:
> However for my boot device, this is going to be a royal pain in the
> butt for developers who wish to boot test kernels with a / sitting on
> a 1280.

Not so. All they have to do is choose to build the firmware into their
kernel, and it works as it always did.

-- 
dwmw2

