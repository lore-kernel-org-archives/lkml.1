Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbXHaAAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbXHaAAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 20:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbXHaAAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 20:00:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:45743 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXHaAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 20:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FTzwneyPwPgXjnkTtXCsn06BMNM5dzdiHt7Fr9lXKwfosBhHB6kB2TmMhtu2DgJmf9yBFkeF5GvJGuaiSbxfrHR7Ru1WtUSU4AwJhn/PCB7FMcxe76WhqKTapWWYnIVhBvNtN5eIrQ8vBjryUZe4fjnHG8SWl25zXSIdm2tIGkA=
Message-ID: <9a8748490708301700y1de4347cubb78c1f82dce4821@mail.gmail.com>
Date: Fri, 31 Aug 2007 02:00:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, rob@landley.net, werner@almesberger.net,
       hpa@zytor.com
In-Reply-To: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/2007, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> initrd/initramfs/ramdisk docs:
> - fix typos/spellos/grammar
> - clarify RAM disk config location
> - correct cpio option
>
> Cc: Bryan O'Sullivan <bos@serpentine.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Werner Almesberger <werner@almesberger.net>
> Cc: H. Peter Anvin <hpa@zytor.com>
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
...

Hi Randy,

I read through your changes and they seem reasonable to me, so for
what it's worth;

Acked-by: Jesper Juhl <jesper.juhl@gmail.com>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
