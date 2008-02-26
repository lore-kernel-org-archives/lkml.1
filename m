Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbYBZWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbYBZWVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYBZWVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:21:00 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:25741 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752282AbYBZWU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:20:59 -0500
Date: Wed, 27 Feb 2008 07:20:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: ysato@users.sourceforge.jp, linux-kernel@vger.kernel.org
Subject: Re: h8300 drivers/serial/sh-sci.c compile error
Message-ID: <20080226222052.GA10606@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, ysato@users.sourceforge.jp,
	linux-kernel@vger.kernel.org
References: <20080226173536.GC8287@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226173536.GC8287@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:35:36PM +0200, Adrian Bunk wrote:
> Commit e108b2ca2349f510ce7d7f910eda89f71d710d84 broke the compilation of 
> drivers/serial/sh-sci.c on h8300:
> 
I have a fix for this in my current queue, it will be batched with the
-rc4 updates.
