Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbYIWL5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbYIWL5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYIWL45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:56:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:64415 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYIWL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=S3OpozvhBQ1Ybds3hDPf0hHJQSpIOjzamJlYe8NLl9UzwRqlBd5R84HZEbIrSUMLD+
         oiFDWJz+BGiauqxATbv9IZ6VnyTeFaYzh8QQ/3qI/aIgTTETe2pAs8AcgmQGU2yHDCwk
         SIZB3ZZogjdJrnK8arFhc3eUoVHKC8vquRZSQ=
Message-ID: <517f3f820809230456r66fa68dcw2362b214ca1de5f6@mail.gmail.com>
Date: Tue, 23 Sep 2008 13:56:56 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Remi Machet" <rmachet@slac.stanford.edu>, jens.axboe@oracle.com
Subject: Re: SPLICE_F_MOVE
Cc: "Linux Mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1222125940.1313.83.camel@pcds-ts102.slac.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222125940.1313.83.camel@pcds-ts102.slac.stanford.edu>
X-Google-Sender-Auth: 0c22ac000bc2a1b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=Jens, who should be able to help]

On 9/23/08, Remi Machet <rmachet@slac.stanford.edu> wrote:
> Hi,
>
>  Does anyone know if SPLICE_F_MOVE is obsolete or still in use ?
>
>  The documentation says that the flag should be used to tell splice not
>  to copy the data when moving data to/from a pipe, but I cannot find
>  anywhere in the kernel where this flag is being used or checked for.
>
>  Thanks,
>
>  Remi
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
