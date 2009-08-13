Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZHMDEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZHMDEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZHMDEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:04:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32855 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZHMDEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:04:32 -0400
Date: Thu, 13 Aug 2009 12:04:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 04/14] sh: use printk_once
Message-ID: <20090813030433.GD2701@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com> <1249847649-11631-5-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249847649-11631-5-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 09:53:59PM +0200, Marcin Slusarz wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: linux-sh@vger.kernel.org
> ---
>  arch/sh/mm/ioremap_64.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
Applied, thanks.
