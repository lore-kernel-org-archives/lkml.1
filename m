Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYH0OFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYH0OFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYH0NxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:53:25 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:59567 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270AbYH0NxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:53:24 -0400
Date: Wed, 27 Aug 2008 22:53:23 +0900 (JST)
Message-Id: <20080827.225323.118975574.anemo@mba.ocn.ne.jp>
To: sfalco@harris.com
Cc: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       will.newton@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <48B55788.5050306@harris.com>
References: <48B4159A.9070907@harris.com>
	<20080827.213551.72707274.anemo@mba.ocn.ne.jp>
	<48B55788.5050306@harris.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 09:32:56 -0400, "Steven A. Falco" <sfalco@harris.com> wrote:
> Add support for M41T65 Real Time Clock chip.
> 
> Signed-off-by: Steven A. Falco <sfalco@harris.com>
> ---
> 
> Ok - here is a respin with the Kconfig modded to indicate support for
> the M41T65.

Thanks, looks fine for me.

Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
