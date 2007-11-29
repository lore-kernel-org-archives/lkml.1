Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXK2Bcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXK2Bcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759061AbXK2Bcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:32:35 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:54638 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbXK2Bce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:32:34 -0500
Message-ID: <474E16AF.8020309@tiscali.nl>
Date: Thu, 29 Nov 2007 02:32:31 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: kernel@wantstofly.org, Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] asm-arm/{arch-omap,arch-ixp23xx}: parentheses around
 NR_IRQS definition
References: <474E10BA.8020704@tiscali.nl>
In-Reply-To: <474E10BA.8020704@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Add parentheses to prevent operator precedence errors
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

For the arch-ixp23xx part I should have added:
Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
