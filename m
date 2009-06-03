Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZFCJDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZFCJDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFCJDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:03:41 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:39342 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZFCJDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:03:40 -0400
Date: Wed, 3 Jun 2009 10:02:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver (v2)
Message-ID: <20090603090238.GH23561@linux-mips.org>
References: <1243954462-18149-1-git-send-email-anemo@mba.ocn.ne.jp> <1243973584.22069.182.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243973584.22069.182.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:13:04PM -0500, Matt Mackall wrote:

> On Tue, 2009-06-02 at 23:54 +0900, Atsushi Nemoto wrote:
> > This patch adds support for the integrated RNG of the TX4939 SoC.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Ok, I'll send this to Linus for 2.6.31 then.

Thanks,

   Ralf
