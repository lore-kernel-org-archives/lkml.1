Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZFDMx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZFDMx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZFDMxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:53:48 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:42698 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbZFDMxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:53:38 -0400
Date: Thu, 4 Jun 2009 13:46:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>
Subject: Re: [PATCH 4/6] headers_check fix: mips, ioctl.h
Message-ID: <20090604124631.GB19459@linux-mips.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <1244118599.5172.31.camel@ht.satnam> <1244118714.5172.33.camel@ht.satnam> <1244118949.5172.37.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244118949.5172.37.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 06:05:49PM +0530, Jaswinder Singh Rajput wrote:

> Make ioctl.h compatible with asm-generic/ioctl.h and userspace
> 
> fix the following 'make headers_check' warning:
> 
>   usr/include/asm-mips/ioctl.h:64: extern's make no sense in userspace
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Thanks, applied.

   Ralf
