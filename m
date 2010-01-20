Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539Ab0ATUc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0ATUc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429Ab0ATUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:32:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45493 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0ATUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:32:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5867"; a="32408856"
Subject: Re: [PATCH] msm_sdcc.c: missing brackets in msmsdcc_resume()
From: Daniel Walker <dwalker@codeaurora.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B536430.6000704@gmail.com>
References: <4B536430.6000704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 12:32:43 -0800
Message-ID: <1264019563.31882.22.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 20:25 +0100, Roel Kluin wrote:
> Since the curly brackets were missing the test and enable_irq(),
> if true, occurred twice.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks .. I'll queue it for 2.6.34 ..

Daniel

