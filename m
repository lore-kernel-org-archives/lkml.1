Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYACXhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYACXhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYACXhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:37:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:62663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYACXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dCcsvqI//TWlusswfssS1pq4YjVXHRwCZ0BArL7gBvgj38PfaUCoaZaFZXJIchzVNTPStslHdKsnsu2k+6SJLr1k1Dxeleh1nsLtXMBrgrRSKKz0vM/XLlvkt50Z+3Nzt6YE8Fdwt9287UTkWTJggn+XaZu2lXX8VmTONLJzo+I=
Message-ID: <9a8748490801031537j15555b74rdda82e49d19f500b@mail.gmail.com>
Date: Fri, 4 Jan 2008 00:37:06 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by checkpatch.pl
Cc: mingo@elte.hu, "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080104003253.7a7309d8@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104003253.7a7309d8@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2008, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> Before:
> total: 25 errors, 13 warnings, 602 lines checked
>
> After:
> total: 3 errors, 13 warnings, 602 lines checked
>
>
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>

Looks sane to me.

Reviewed-by: Jesper Juhl <jesper.juhl@gmail.com>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
