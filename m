Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbXDBRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbXDBRfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXDBRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:35:51 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:51001 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbXDBRft convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:35:49 -0400
Date: Mon, 2 Apr 2007 18:35:44 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: mmap error?
Message-ID: <20070402173544.GA19343@deepthought>
References: <200704021030.29747.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200704021030.29747.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gene,

On Mon, Apr 02, 2007 at 10:30:29AM -0400, Gene Heskett wrote:
> Greetings all;
> 
> Has something been changed recently, say post 2.6.19, that would effect 
> this error from k3b when I click start (the burn), with a fresh dvd+r in 
> the drive:
> 
> --------
> Using growisofs 7.0 Copyright (C) Andy Polyakov <appro@fy.chalmers.se>
> Starting writing...
> :-( unable to anonymously mmap 33554432; resource temporarily 
> unavailable...
> Fatal error at startup, resource temporarily unavailable...
> --------
 Known problem, please see
http://fy.chalmers.se/~appro/linux/DVD+RW/tools/ (third paragraph)
for a workaround.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
