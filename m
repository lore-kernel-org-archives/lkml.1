Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZFBUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZFBUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZFBUOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:14:14 -0400
Received: from waste.org ([66.93.16.53]:39750 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZFBUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:14:13 -0400
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver (v2)
From: Matt Mackall <mpm@selenic.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
In-Reply-To: <1243954462-18149-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1243954462-18149-1-git-send-email-anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 15:13:04 -0500
Message-Id: <1243973584.22069.182.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 23:54 +0900, Atsushi Nemoto wrote:
> This patch adds support for the integrated RNG of the TX4939 SoC.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


