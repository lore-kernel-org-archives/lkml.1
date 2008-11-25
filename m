Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYKYREz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYKYREz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYKYREn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:04:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYKYREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:04:42 -0500
Date: Tue, 25 Nov 2008 12:04:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Kyle Mc Martin <kyle@hera.kernel.org>,
       linux-parisc@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] parisc: fix bug in compat_arch_ptrace
Message-ID: <20081125170441.GC30056@bombadil.infradead.org>
References: <200811201054.09930.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811201054.09930.deller@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 10:54:09AM +0100, Helge Deller wrote:
> This commit in 2.6.28-rc:
> 	81e192d6ce303b6792aa38ff35f41a1a7357f23a
> 	parisc: convert to generic compat_sys_ptrace
> 
> introduced a bug which segfaults the parisc 64bit kernel 
> when stracing 32bit applications:
> 

Thanks, looks fine.

