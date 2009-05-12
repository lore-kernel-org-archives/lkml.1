Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZELJ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZELJ16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZELJ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:27:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45241 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZELJ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:27:47 -0400
Message-ID: <4A094110.3030501@monstr.eu>
Date: Tue, 12 May 2009 11:27:44 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 00/12] Microblaze fixes for 2.6.31
References: <20090511232019.927138561@arndb.de>>
In-Reply-To: <20090511232019.927138561@arndb.de>>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Hi Michal,
> 
> These are some cleanups and bug fixes that I came
> across while working on my asm-generic headers.
> 
> Since I don't have actual hardware, they are
> compile tested only. Please test and queue up
> for 2.6.31.
> 
> Feel free to pull the whole series from
> git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git microblaze-cleanups

All changes except this one ([PATCH 11/12] microblaze: dont include asm/mmu.h in
hw_exception_handler) were added to for-linus branch

Thanks,
Michal


> 
> 	Arnd <><
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
