Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZDXO6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZDXO6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZDXO5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:57:54 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:47066 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZDXO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:57:54 -0400
Date: Fri, 24 Apr 2009 16:57:35 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v3)
Message-ID: <20090424145735.GA5930@linux-mips.org>
References: <1240414831-20429-1-git-send-email-anemo@mba.ocn.ne.jp> <e9c3a7c20904240749g79b7b54cufa64149e44b5753a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20904240749g79b7b54cufa64149e44b5753a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 07:49:10AM -0700, Dan Williams wrote:

> On Wed, Apr 22, 2009 at 8:40 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > This patch adds support for the integrated DMAC of the TXx9 family.
> >
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Thanks, queued for 2.6.31.

  Ralf
