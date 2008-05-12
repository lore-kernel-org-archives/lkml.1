Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYELUm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYELUm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYELUmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:42:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:48383 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753646AbYELUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:42:45 -0400
Date: Tue, 13 May 2008 05:41:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] sh: use the common ascii hex helpers
Message-ID: <20080512204128.GB17005@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1210619144.24092.62.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210619144.24092.62.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 12:05:43PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/sh/kernel/kgdb_stub.c |   11 +++++------
>  drivers/serial/sh-sci.c    |    8 ++++----
>  include/asm-sh/kgdb.h      |   14 --------------
>  3 files changed, 9 insertions(+), 24 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
