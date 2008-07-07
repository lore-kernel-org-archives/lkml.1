Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYGGN7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYGGN7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYGGN6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:58:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:34394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYGGN6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:58:52 -0400
Date: Mon, 7 Jul 2008 06:58:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, mgross@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move the descriptions of VT-d to
 Documentations/x86/x86_64/boot-options.txt
Message-ID: <20080707065816.29833aca@infradead.org>
In-Reply-To: <20080707171707V.fujita.tomonori@lab.ntt.co.jp>
References: <20080707171707V.fujita.tomonori@lab.ntt.co.jp>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 17:17:11 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Documentations/x86/x86_64/boot-options.txt is the more appropriate
> place for the descriptions of the VT-d IOMMU kernel parameters.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  Documentation/kernel-parameters.txt       |   22
> ---------------------- Documentation/x86/x86_64/boot-options.txt |


I disagree.
Documentation/kernel-parameters.txt needs to contain ALL of them.
It already can deal with some of them being only for some
architectures, but it really should be the one-stop-shop for kernel
parameters.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
