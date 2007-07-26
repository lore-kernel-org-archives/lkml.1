Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXGZXme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXGZXme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbXGZXm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:42:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60828 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbXGZXm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d6a0WFB7V+/CPgLB1KFT/wYA8f0alraOmVO6XcLhLLf1zDc1DYRz7PJZNXTCipLZGglj9z82LshZJJ/dzyEijZhD3icQTNkOcFzI/EU1zYHle6L5SHNZbU60GvXeC8SHVGl4fbQ485fErNHPn6rPszBKR18kWTK2GhvPhKqCIS8=
Message-ID: <9a8748490707261642sadcc316la3dcd0ef7201dd68@mail.gmail.com>
Date: Fri, 27 Jul 2007 01:42:26 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] various doc/kernel-parameters fixes
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       tony.luck@intel.com, jejb <james.bottomley@steeleye.com>
In-Reply-To: <20070726164429.f41358d7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726164429.f41358d7.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> - tell what APIC (by request), MTD, & PARIDE mean
> - correct some source file names
> - remove IA64 "llsc*=" (seems to have been removed from source tree)
> - removel SCSI "53c7xx=" (driver already removed)
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

I read through your changes and they look good to me.

Acked-by: Jesper Juhl <jesper.juhl@gmail.com>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
