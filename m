Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZLXGsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZLXGsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZLXGsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:48:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1412 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbZLXGsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:48:11 -0500
Subject: Re: [PATCH] scripts/get_maintainer.pl: add support to read patch
 from STDIN
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091224064556.GA26621@liondog.tnic>
References: <9ea470500912230555k6b72407al730da6361d8aba0f@mail.gmail.com>
	 <1261610824.1923.58.camel@Joe-Laptop.home>
	 <20091224064556.GA26621@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 22:48:09 -0800
Message-ID: <1261637289.1923.72.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 07:45 +0100, Borislav Petkov wrote:
> This breaks current usage and possibly other scripts:
> 
> # git diff | ./scripts/get_maintainer.pl -
> ./scripts/get_maintainer.pl: file '-' not found
> 
> Just do it as it is done at http://lkml.indiana.edu/hypermail/linux/kernel/0801.1/1654.html

How can it break current usage when it's a new feature?



