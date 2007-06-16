Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXFPARZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXFPARZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXFPARQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:17:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:45727 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbXFPARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WP7dvGqMj305bfDhWwjIYm4wLqQJ8wswKDocjM5pkV9GPxKKGSyjTNYGsfUpS4mwD/6G32919f4mqCt8/nT+NLW/0lOMLwjScGxy/qa9mSbK3+FMg4qONEE3Wqr176zkVK7VCeSFZ3tt6d5J6C7LxafrbZCa4YaCIYoF1Wh9ch0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] drivers/ide/ide-dma.c: unexport ide_set_dma
Date: Sat, 16 Jun 2007 02:18:01 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070614221642.GD3588@stusta.de>
In-Reply-To: <20070614221642.GD3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706160218.01278.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Adrian Bunk wrote:
> ide_set_dma no longer has any modular user.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied
