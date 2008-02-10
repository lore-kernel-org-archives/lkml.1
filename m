Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYBJGjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYBJGjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYBJGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:38:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:50579 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYBJGi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bgp2P6EpTBEI9Lst7Aj7DtaJh4hRbcD3K8kViCiJ8QySHFS+c+xzQFepqmLRjZzXICxbAnATQOLBULVXlS2bl44MBdCxIi/RAaZMuqd/GCdGe1mJWSdsQToxOij8Zwi65qwpVBspVOP11Hezmhru7LoDz0UYmvY6on+jnUsmmho=
Message-ID: <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
Date: Sun, 10 Feb 2008 08:38:55 +0200
From: "Niki Denev" <ndenev@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <20080210063247.GQ8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 8:32 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Sun, Feb 10, 2008 at 08:04:35AM +0200, Niki Denev wrote:
> > Hi,
> >
> > As the subject says the 2.6.24.1 is still vulnerable to the vmsplice
> > local root exploit.
>
> Yes indeed, that's quite bad. 2.6.24-git is still vulnerable too, and
> also contains the fix :-(
>
> CC'd Jens as he worked on the fix.
>
> Willy
>
>

I was unable to gain root on 2.6.24-git20
but after several segfaults when executing the exploit continously
the machine crashes.

--Niki
