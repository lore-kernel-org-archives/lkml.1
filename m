Return-Path: <linux-kernel-owner+w=401wt.eu-S934364AbXK3CDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbXK3CDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761361AbXK3CDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:03:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114AbXK3CDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:03:09 -0500
Message-ID: <474F6E7A.3090705@redhat.com>
Date: Thu, 29 Nov 2007 20:59:22 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
In-Reply-To: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> NOTE: This patch uses a bc(1) script to compute the appropriate
> constants.

Perhaps dc would be more appropriate?  That's included in busybox.

	-- Chris
