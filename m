Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbYB1QOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbYB1QOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYB1QO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:14:27 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:53188 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYB1QO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:14:27 -0500
Date: Thu, 28 Feb 2008 16:14:24 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mips: use KBUILD_DEFCONFIG
Message-ID: <20080228161424.GA10876@linux-mips.org>
References: <20080226195454.GC4898@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226195454.GC4898@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 09:54:54PM +0200, Adrian Bunk wrote:

> With KBUILD_DEFCONFIG we don't have to ship a second copy of 
> ip22_defconfig

Thanks, applied.

  Ralf
