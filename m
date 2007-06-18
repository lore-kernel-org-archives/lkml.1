Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbXFRV7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbXFRV7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763730AbXFRV7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:59:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17361 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763296AbXFRV7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B1YwiO7oX/MEib6SekFELfyKVCaX96I/quH81UjczU4/o+4Wutf71iJxaG2ejNJOA1Gp1zrpwYKFYuE7zK1BO2qUuc1gMx5TB9KDUUzvuXAulDrhy4M6Jyutv/UIV4Jkw/pTZpCfk6Y6rvzbOeu92rf0RINI7xACZovjp5PAE5w=
Message-ID: <29495f1d0706181459t67ec0371i4b6ffcf7ac991dea@mail.gmail.com>
Date: Mon, 18 Jun 2007 14:59:42 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Chris Wright" <chrisw@sous-sol.org>
Subject: Re: Linux 2.6.21.5
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20070611201418.GA3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611201418.GA3723@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Chris Wright <chrisw@sous-sol.org> wrote:
> We (the -stable team) are announcing the release of the 2.6.21.5 kernel.
> This has a variety of important fixes, see below for the summary.
>
> I'll also be replying to this message with a copy of the patch between
> 2.6.21.4 and 2.6.21.5
>
> The updated 2.6.21.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=summary

While linux-2.6.21.y is moving forward, it would appear that
linux-2.6-stable is back several releases?

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=summary
shows 2.6.21.1 as the last 2.6.21.Y release. Is that intentional?

Thanks,
Nish
