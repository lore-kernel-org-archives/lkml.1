Return-Path: <linux-kernel-owner+w=401wt.eu-S968068AbXG3THo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968068AbXG3THo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967987AbXG3THY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:07:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:59575 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967392AbXG3THV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TIaiCfigltfknG5xzIJUErKyvEJ49rZI/LJZ4O7JMzSASyWHTn9ym8SNkZ+Y0I6ukAxqHr2tpHdCLWQ3oSZICHZ9YYSLMQI/XEBt7U+v6LoecxmOsp8ToYrOROTypfA21ZdVpOmhCCmO0qvwZtMqjKsqwQxwhucGVLmqgBNQWV4=
Date: Mon, 30 Jul 2007 23:07:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Remove fs.h from mm.h
Message-ID: <20070730190715.GB5776@martell.zuzino.mipt.ru>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org> <swfhcnmhwqo.wl%takata.hirokazu@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <swfhcnmhwqo.wl%takata.hirokazu@renesas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 10:00:47PM +0900, Hirokazu Takata wrote:
> This change breaks m32r, too.

Apologies. I just finished adding m32r to my cross-build setup, so there
shouldn't be any more such breakages.

