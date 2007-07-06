Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbXGFAKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbXGFAKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbXGFAJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:09:59 -0400
Received: from gw.goop.org ([64.81.55.164]:41982 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbXGFAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:09:59 -0400
Message-ID: <468D8855.9060205@goop.org>
Date: Thu, 05 Jul 2007 17:09:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com
Subject: Re: [-mm patch] make arch/i386/xen/mmu.c:xen_pgd_pin() static
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070705232255.GX3492@stusta.de>
In-Reply-To: <20070705232255.GX3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> xen_pgd_pin() can become static.
>   

Hold off on that for now.  I have some local patches which add other 
xen/ files which use it.

    J
