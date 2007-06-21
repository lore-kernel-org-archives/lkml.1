Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbXFUQRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbXFUQRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXFUQRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:17:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35497 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752792AbXFUQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:17:43 -0400
Date: Thu, 21 Jun 2007 18:17:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signed binaries support [0/4]
Message-ID: <20070621161758.GP12950@stusta.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 05:55:16PM +0200, Johannes Schlumberger wrote:

> Hi,

Hi Johannes,

> We (two students of CS) built a system for signing binaries and verifying them
> before executing. Our main focus was to implement a way to inhibit execution
> of suid-binaries, which are not trustworthy (i.e. not signed).
>...

doesn't anyone who is able to install a not trustworthy suid-binary 
already have the priviliges to do anything he wants to without requiring 
an suid bit?

> regards,
> 	Johannes
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

