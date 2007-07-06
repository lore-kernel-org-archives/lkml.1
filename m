Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbXGFVaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbXGFVaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763013AbXGFVaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:30:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59962 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762992AbXGFVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:30:14 -0400
Subject: Re: 2.6.22-rc6-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Jul 2007 14:31:52 -0700
Message-Id: <1183757512.21234.20.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 03:43 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> 

fs/xfs/linux-2.6/xfs_ioctl32.c: In function ‘xfs_ioc_bulkstat_compat’:
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: ‘xfs_inumbers_fmt_compat’
undeclared (first use in this
function)fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared
identifier is reported only once
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears
in.)
make[2]: *** [fs/xfs/linux-2.6/xfs_ioctl32.o] Error 1




