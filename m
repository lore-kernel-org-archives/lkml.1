Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbXHPTkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbXHPTkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760942AbXHPTju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:39:50 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:45536 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbXHPTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dEjKXSC5QNEnpUJwFCog8r8iWfv+H7FRZ8ddI7HFbWoS0KPUbcgIhV+2crPvL/A/cplc+kUEs16/rmoHl1Js7zdYIv7XoW72KaRtXZkpzDUqdXJRKJyBt6dcbiwzhrE0qbfTkW9RGrkHsF62SlpYzfjCdUHTSz6Fk9oUszXOx70=
Message-ID: <8bd0f97a0708161239p499247baqd32b2c1eabcab819@mail.gmail.com>
Date: Thu, 16 Aug 2007 15:39:45 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] Add a new field `name' to struct linux_binfmt
Cc: "Jie Zhang" <jie.zhang@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070816192447.GA5875@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187248823.11475.24.camel@mercury.analog.com>
	 <20070816192447.GA5875@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Aug 16, 2007 at 03:20:23PM +0800, Jie Zhang wrote:
> > A second blackfin arch patch will use this field to distinguish `flat'
> > binfmt with `FDPIC ELF'.
>
> Please, post it. It a bit hard to see what you're actually trying to do.

he already did ...
http://article.gmane.org/gmane.linux.kernel/571072
-mike
