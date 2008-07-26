Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYGZQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYGZQK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYGZQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:10:11 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:1354 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYGZQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n54aaNeH7G6rqDVpSZWRVoOcYjCdbOxSc+mXUMaF+jbtaRslpWl8XfaMHMyVJWj29G
         /MZZuw8p83p7ZR0JWm1kyXM9FbGgICXXidVvhWQ31ZGQ1Fp1gTM7D1GhyMCemTOhQA8u
         0la06XTBcWKwqCYppQYuY3STtIj3n3XC9Tojk=
Message-ID: <961aa3350807260910q1e7deea3jb4e7f51691543b6c@mail.gmail.com>
Date: Sun, 27 Jul 2008 01:10:07 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] nwflash: fix build errors and warning
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tim@physik3.uni-rostock.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080726153210.GD8871@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807250848.m6P8mIWF001718@imap1.linux-foundation.org>
	 <20080726141808.GB8871@flint.arm.linux.org.uk>
	 <20080726150155.GA3562@localhost.localdomain>
	 <20080726153210.GD8871@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sorry. I'm preparing cross compiler. But this patch should fix this
>> problem.
>
> I sort of did the same - but merely changing the names of the variables
> generates other warnings.  More complete (and build-tested) commit
> queued up:
>
> http://ftp.arm.linux.org.uk/git/gitweb.cgi?p=linux-2.6-arm.git;a=commitdiff;h=4ef584ba84125b67c17b5aded38e7783cd8cdef0
>

Ah, thanks for fixing that.
