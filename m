Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0CKKxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:53:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32936 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab0CKKxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:53:32 -0500
Date: Thu, 11 Mar 2010 11:53:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/4 v2] x86: remove rdc321x_defs.h
Message-ID: <20100311105324.GA27207@elte.hu>
References: <201003110942.06367.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003110942.06367.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Fainelli <florian@openwrt.org> wrote:

> This file is going to be replaced with a cleaner version with the adding of 
> a MFD driver for the southbridge.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Acked-by: Ingo Molnar <mingo@elte.hu>

Feel free to carry it in the driver tree that ends up picking up the other 
patches. (the MTD tree?)

Thanks,

	Ingo
