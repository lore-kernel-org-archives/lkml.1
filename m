Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbXERSr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbXERSr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXERSrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:47:52 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:57903 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbXERSrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZMxaS6gNtQoN5Q4Z0SJUYT10eQuG5belUzmanXDLBIn1wtxTM/XBa9cbCmj5RJsNZ4zJ3wdiVUFEM4jf97aAjDIlFTBlQaZF4eFOFGuwUzce3mLmzftDhEf6z+Mo/5h8bhAexTFiM+Q8T9/Ti98bDfL6a7SGSp0JG7QtMP32+kk=
Message-ID: <4af2d03a0705181147h337c1841ya13525c1065921e0@mail.gmail.com>
Date: Fri, 18 May 2007 20:47:50 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Char: cyclades, add firmware loading
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070518111048.55e9d811.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2258930840122446564@wsc.cz>
	 <20070518111048.55e9d811.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 18 May 2007 19:49:11 +0200 (CEST)
> Jiri Slaby <jirislaby@gmail.com> wrote:
> > cyclades, add firmware loading
[...]
> The second patch fixes a bug in 2.6.22-rc1 and in 2.6.21 (yes?) but

I think, the bug is there since the driver merge (original driver
available on vendor's site contain this issue too), so yes.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
