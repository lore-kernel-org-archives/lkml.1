Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbXGFAKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbXGFAKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761134AbXGFAKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:10:16 -0400
Received: from gw.goop.org ([64.81.55.164]:41996 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762981AbXGFAKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:10:14 -0400
Message-ID: <468D8864.5030709@goop.org>
Date: Thu, 05 Jul 2007 17:10:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com
Subject: Re: [-mm patch] arch/i386/xen/events.c should #include	<asm/xen/hypervisor.h>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070705232224.GT3492@stusta.de>
In-Reply-To: <20070705232224.GT3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Every file should include the headers containing the prototypes for
> its global functions

OK.

    J
