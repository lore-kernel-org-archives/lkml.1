Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZK3UD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZK3UD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZK3UD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:03:28 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:42085 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZK3UD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:03:27 -0500
Date: Mon, 30 Nov 2009 20:03:19 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/1] MIPS: Wire up recvmmsg syscall
Message-ID: <20091130200319.GA26639@linux-mips.org>
References: <1259610615-23996-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259610615-23996-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 05:50:15PM -0200, Arnaldo Carvalho de Melo wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  arch/mips/include/asm/unistd.h |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)

Looks good.  Dave, wanna merge this through the netdev tree?

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
