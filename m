Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXBZT3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXBZT3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030486AbXBZT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:29:13 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:40311 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480AbXBZT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:29:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fq/FwTJAq/v7+uXhEc9bjiu0YVgK1NIgptKQ/1hDOvVzdNCCRrUW5g4T4Unn1cmCpFH0n6L8GN0iYMC7Iajz9gFxOg6W+cx5IfCJ8kxlgCqwH/mp/Ur0cW6/B/bafi48Eb18bJ3SmKe4YqOL7/uV5cnX+/obMfzVX7W3GX92bRg=
Message-ID: <e5bfff550702261129p5085bd22gae11c81b401d3591@mail.gmail.com>
Date: Mon, 26 Feb 2007 20:29:10 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Johannes Schindelin" <Johannes.Schindelin@gmx.de>
Subject: Re: [ANNOUNCE] qgit-1.5.5
Cc: "Martin Langhoff" <martin.langhoff@gmail.com>,
       "Git Mailing List" <git@vger.kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0702261846010.22628@wbgn013.biozentrum.uni-wuerzburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550702250958n6cddc5b5lec4badf1f7fc8231@mail.gmail.com>
	 <46a038f90702251623h5944a085m514418cb5f530e7f@mail.gmail.com>
	 <e5bfff550702252219m352c03ady2d810e051bd62a37@mail.gmail.com>
	 <Pine.LNX.4.63.0702261218430.22628@wbgn013.biozentrum.uni-wuerzburg.de>
	 <e5bfff550702260939t4a071d34o6bbf3dcd4ad5b67c@mail.gmail.com>
	 <Pine.LNX.4.63.0702261846010.22628@wbgn013.biozentrum.uni-wuerzburg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/07, Johannes Schindelin <Johannes.Schindelin@gmx.de> wrote:
> Hi,
>
> On Mon, 26 Feb 2007, Marco Costalba wrote:
>
> > Actually, I didn't test with MinGW port of Git but I would be surprised
> > if it doesn't work (famous last words ;-)  )
>
> You don't use cygpath to translate between Windows <-> POSIX filenames?
>
> AFAICT this is the single most important user-visible difference between
> Cygwin Git and MinGW Git.
>

I call git programs as if they were native windows programs. I run git
programs without requiring cygwin shell or something similar.

I hope I have understood correctly your answer.

Marco
