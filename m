Return-Path: <linux-kernel-owner+w=401wt.eu-S1765327AbXHXMvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765327AbXHXMvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbXHXMvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:51:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:4066 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762224AbXHXMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=l2+PQpIUPhF+ttQotal2nQAKFhf6Z7zqZYlbfP+tmX2YkJkC3qMLgd37bDTs+35jep3F0/4xJUDNUWv9E403DZXvo92sRpfYb5AMZfh9npwRqkC8JarqHpGjtrYaqsxdlFvM5RXg4nTg6TGbX0WGawk5ptWVuyJsQ6G6p8wucHQ=
Message-ID: <ed10ee420708240550s3416519cuedd371daa9249f8a@mail.gmail.com>
Date: Fri, 24 Aug 2007 05:50:56 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: false positive in checkpatch.pl (complex macro values)
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
	 <46CEC3D4.40805@shadowen.org>
	 <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
X-Google-Sender-Auth: a69ddc312a42bb62
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, SL Baur <steve@xemacs.org> wrote:

> I think the
> error message is wrong.

I mean the error message is badly worded.  That's bad C and the
macro needs deletion a lot more than it needs an extra set of parens.

Been chasing a heisen bug too long.  Need sleep.  Sorry.

-sb
