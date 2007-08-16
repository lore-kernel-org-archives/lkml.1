Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXHPTZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXHPTZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXHPTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:24:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:59553 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbXHPTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HrFYvb6FHxbzB/Q7re8FbP10RLv5peIuEx9jTKShHBAgbqo/00gRukhkRU+P3h/Lq+H7/FMlfH06Y0dDsriOEwvq6Bu8KgxIBiyPX05xo5uWUQlnr0W2jxiT5PI7GtMl4vJrDR1hEhiqkWu7WbozIRh3IFmdhwuQhUhyptOJ5v0=
Date: Thu, 16 Aug 2007 23:24:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jie Zhang <jie.zhang@analog.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add a new field `name' to struct linux_binfmt
Message-ID: <20070816192447.GA5875@martell.zuzino.mipt.ru>
References: <1187248823.11475.24.camel@mercury.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187248823.11475.24.camel@mercury.analog.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 03:20:23PM +0800, Jie Zhang wrote:
> A second blackfin arch patch will use this field to distinguish `flat'
> binfmt with `FDPIC ELF'.

Please, post it. It a bit hard to see what you're actually trying to do.

