Return-Path: <linux-kernel-owner+w=401wt.eu-S937876AbZLHUpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937876AbZLHUpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZLHUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:45:19 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25692 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZLHUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:45:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5826"; a="29396842"
Subject: Re: HTC Dream: mmc compilation fixes
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
In-Reply-To: <20091206195953.GA26863@elf.ucw.cz>
References: <20091206195953.GA26863@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 12:45:22 -0800
Message-ID: <1260305123.11826.25.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 20:59 +0100, Pavel Machek wrote:
> +
> +struct embedded_sdio_data {
> +        struct sdio_cis cis;
> +        struct sdio_cccr cccr;
> +        struct sdio_embedded_func *funcs;
> +        int num_funcs;
> +};


There's some indentation problems in this block, I'll fix it prior to
merging it..

Daniel

