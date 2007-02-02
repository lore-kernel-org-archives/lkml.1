Return-Path: <linux-kernel-owner+w=401wt.eu-S1423175AbXBBIJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423175AbXBBIJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945902AbXBBIJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:09:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38791 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423198AbXBBIJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:09:04 -0500
Date: Fri, 2 Feb 2007 00:05:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       takada <takada@mbf.nifty.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Please revert "fix typo in geode_configre()@cyrix.c"
Message-Id: <20070202000543.c3664ecc.akpm@linux-foundation.org>
In-Reply-To: <20070202062941.GB3754@stusta.de>
References: <20070202062941.GB3754@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 07:29:41 +0100 Adrian Bunk <bunk@stusta.de> wrote:

> Linus, please revert commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> 

Yup.

That discussion seems to have died.  The 2.6.19 code looks rather silly, but
presumably it passed someone's testing at some stage.
