Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYJQPJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYJQPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYJQPFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:44 -0400
Received: from h4.dl5rb.org.uk ([81.2.74.4]:43877 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754759AbYJQPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:42 -0400
Date: Fri, 17 Oct 2008 16:05:29 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-mips@linux-mips.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix debugfs_create_*'s error checking method for
	mips/math-emu/
Message-ID: <20081017150529.GB15932@linux-mips.org>
References: <48F8731E.40100@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F8731E.40100@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 07:12:30PM +0800, Zhaolei wrote:

> debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.

Thanks, applied.

  Ralf
