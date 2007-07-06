Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbXGFAYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbXGFAYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbXGFAYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:24:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:21794 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXGFAYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SQJIz2sB3PkdwfUZAnD38vTn33kv7+88jId0QNWHmIbB0h9LbEQVAVBnE/UCWfe+pWNy7uesHPjS+tw1g+ma1kUfQPm52kQECYDojin6SnfHzgpcvSRB0x5xNd3xrToUZ9QrKva1Il9DyJ3hIcw85OLR8wQyCx9fat0Z0HlZb0M=
Message-ID: <9a8748490707051724x1c2801cexb965bbd0fac95b40@mail.gmail.com>
Date: Fri, 6 Jul 2007 02:24:41 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: bamakhrama@gmail.com
Subject: Re: Linux SMP Porting Guide
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <40378e40707050603k256d2efaifd97669f3f12131e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40378e40707050603k256d2efaifd97669f3f12131e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/07, Mohamed Bamakhrama <bamakhrama@gmail.com> wrote:
> Hi all,
> Is there any mailing list or tutorial which provides guidelines for
> porting Linux SMP into a new architecture?
>
Hmm, not that /I/ know of, but various generic documentation is
available in the Documentation/ directory.

Perhaps if you had a more specific question about some specific
issue/problem it would be easier to help you...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
