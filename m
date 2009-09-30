Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZI3GnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZI3GnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZI3GnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:43:04 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54283 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZI3GnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:43:04 -0400
Date: Wed, 30 Sep 2009 15:42:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Build fix: define __movmem
Message-ID: <20090930064227.GA5967@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Lubomir Rintel <lkundrak@v3.sk>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1254291454-7436-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254291454-7436-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 08:17:34AM +0200, Lubomir Rintel wrote:
> ERROR: "__movmem" [net/irda/irda.ko] undefined!
> ERROR: "__movmem" [fs/nfsd/nfsd.ko] undefined!
> ERROR: "__movmem" [fs/lockd/lockd.ko] undefined!
> ERROR: "__movmem" [crypto/sha1_generic.ko] undefined!
> ---
>  arch/sh/kernel/sh_ksyms_32.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
Applied, thanks.
