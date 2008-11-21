Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYKUENW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYKUENW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKUENI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:13:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:39336 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYKUENF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qrAeD6QMaAP+Ty2BT49n8+JvVioOscL4rhxNCsexzA4rdv1IOuPK95M6jasCuxmHTm
         WtF3jk+0DeucBosNCzicG0ps4BkeO+qCQ0iS4j45Jod1NYMdoe99BewTSkV9OJ6VVPY7
         PpJKrHZNGEl5b8dEb09y3hKdAPMC9qwNFl+/M=
Date: Fri, 21 Nov 2008 07:16:43 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH 2/3] proc: Export statistics for softirq to /proc
Message-ID: <20081121041643.GA5366@x200.localdomain>
References: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp> <20081120195843.c6d0b653.kobayashi.kk@ncos.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120195843.c6d0b653.kobayashi.kk@ncos.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 07:58:43PM -0800, Keika Kobayashi wrote:
> Export statistics for softirq in /proc/softirqs and /proc/stat.

I thought we added debugfs to stop adding these and similar stuff to /proc.
