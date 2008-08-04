Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYHDATr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYHDATr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYHDATf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:19:35 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:9611 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755887AbYHDATe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:19:34 -0400
Date: Mon, 4 Aug 2008 09:18:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/24] sh: use the new byteorder headers
Message-ID: <20080804001842.GA7960@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1217379327.23389.129.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217379327.23389.129.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 05:55:27PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/sh/include/asm/byteorder.h |   32 +++++++++++++++-----------------
>  1 files changed, 15 insertions(+), 17 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
