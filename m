Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbXL2BgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbXL2BgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXL2BgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:36:12 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:42072 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbXL2BgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TokdjXB5ffnXpJL6voyVxkNau+Vp3ZVGL6zce4J2siBTXrr5LdytFQYG6ddmMrSaJsgsqVDaI54/9u1bQgqpkumnRX2qAOIssZKq4fARTwwXMrUnUh6UWtwDAcri92pmqX0xiDmdGyFffwcW5r6riS9naT2OYliTa0vo9y0puD8=
Message-ID: <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
Date: Sat, 29 Dec 2007 09:36:11 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <1198891742.6821.98.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 9:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
>
> I'm pretty sure you didn't boot that kernel with lockdep enabled.
Yes, I will try rebuild with lockdep  and test.
>
> Also, most, if not all, of your patches miss a patch description.

Does the description really needed for it? IMHO, the subject is enough
to descript the patches.

Thanks for comment.

Regards
dave
