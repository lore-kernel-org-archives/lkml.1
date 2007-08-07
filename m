Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbXHGXij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbXHGXij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXHGXi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:38:28 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:53925 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXHGXi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:38:27 -0400
Message-ID: <46B901BD.4040405@gmail.com>
Date: Wed, 08 Aug 2007 01:35:25 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove binfmts.h from header exports
References: <20070807201603.GB31501@aepfle.de>
In-Reply-To: <20070807201603.GB31501@aepfle.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2007 10:16 PM, Olaf Hering wrote:

> remove linux/binfmts.h from make headers_install
> 
> A recent patch added PAGE_SIZE to the part outside of __KERNEL__.
> qemu and ia32el have their own define of MAX_ARG_PAGES.
> No package uses linux/binfmts.h, so it is safe to not provide it.

How is "all packages" defined?

Rene.
