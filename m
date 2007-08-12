Return-Path: <linux-kernel-owner+w=401wt.eu-S938673AbXHLWuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938673AbXHLWuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbXHLWtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:49:52 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:45809 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735AbXHLWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mq91Pm/1jG/htcpVi5lf8zBJ52UEbjkMLtMCaiobOsRR6SGfcZCNkOQ4ndSezv2cZycHwdv+ISs3QQ+B0ndqs2qVLRzw69ZOVUrz+1GR9EcL2HZTMbtibZqrv0/J7PXOiIgPy3fKBrvBuIFh/WjDEq1XJpdZVw1PvK+0CqQcYNA=
Message-ID: <9a8748490708121549m6070243k634930a2c24b7ea2@mail.gmail.com>
Date: Mon, 13 Aug 2007 00:49:50 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] 4KSTACKS, remove DEBUG_KERNEL dependency for sh
In-Reply-To: <20070812224411.GA23556@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708122250.58773.jesper.juhl@gmail.com>
	 <200708122253.24034.jesper.juhl@gmail.com>
	 <20070812224411.GA23556@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Sun, Aug 12, 2007 at 10:53:23PM +0200, Jesper Juhl wrote:
> >
> > 4K Stacks is no longer a debug feature, so remove the DEBUG_KERNEL
> > dependancy for 4KSTACKS for sh.
> >
>
> While it may no longer be a debugging feature on i386, it certainly is on
> sh. It should stay under DEBUG_KERNEL for now.
>
Ok. That was the kind of clear response I was looking for - thank you Paul.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
