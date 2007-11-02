Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbXKBP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbXKBP04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXKBP0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:26:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:57865 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753331AbXKBP0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:26:48 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX187quIm2Ig7UrgyEc1bGpJqD1Y5ClXOSLNCXjIeLD
	4EGYTioFypqjxn
Date: Fri, 2 Nov 2007 16:26:35 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: oops in enqueue_entity with 2.6.24-rc1-g54866f03
Message-ID: <20071102152635.GA18183@alice>
References: <20071102123603.GA4988@alice> <200711021513.14425.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711021513.14425.rjw@sisk.pl>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.24-rc1 (x86_64)
X-Uptime: 16:25:34 up  5:36,  6 users,  load average: 0.00, 0.19, 0.31
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> On Friday, 2 November 2007 13:36, Eric Sesterhenn wrote:
> > hi,
> > 
> > I get the following crash with 2.6.24-rc1-g54866f03, the last version I
> > tested which booted fine was 2.6.24-rc1-gb1d08ac0
> 
> Does 2.6.23 work correctly for you?

2.6.23.1 does work fine, i also tested 2.6.24-rc1, 2.6.24-rc1-g2a397e82
and 2.6.24-rc1-gb1d08ac0 which did well, so this is a recently
introduced regression.

Eric

