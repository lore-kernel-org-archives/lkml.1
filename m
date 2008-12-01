Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbYLAGxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbYLAGxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYLAGwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:52:53 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40035 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbYLAGwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:52:53 -0500
Date: Mon, 1 Dec 2008 15:51:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH-mm 4/7] sh: wire up arch overrides for unaligned access on the SH4a
Message-ID: <20081201065123.GB30438@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>
References: <1228012830.26141.1029.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228012830.26141.1029.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 06:40:30PM -0800, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/sh/include/asm/unaligned-sh4a.h |  258 ----------------------------------
>  arch/sh/include/asm/unaligned.h      |   76 ++++++++--
>  2 files changed, 61 insertions(+), 273 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>

Thanks for looking at this!
