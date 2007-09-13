Return-Path: <linux-kernel-owner+w=401wt.eu-S1765528AbXIMXXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765528AbXIMXXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbXIMXXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:23:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:6063 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbXIMXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tkzl9V0I4i4CtyNRSmd3I/nG/h6AiG1GdQ6O5tASunaMSCHUAKzulxqNM2SnF9F2jvv7FLUJT2MYU9Giz0ibmc7VCGZbd6j+C+FwQpg8f/X4IjcddRz6KwIjsrH4yTBV6SbiBaYNprUS0pD80IFc0npKczo5wHI5Y1OS4Rbbf9c=
Message-ID: <b6a2187b0709131623m78958fa2o77d3be75029d445e@mail.gmail.com>
Date: Fri, 14 Sep 2007 07:23:31 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI video mode patch review
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <46E9AD88.7070400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E9AD88.7070400@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Pavel, want to look at the patch before sending it to Linus?
>
>     [acpi] Correct the decoding of video mode numbers in wakeup.S

HPA,

After a day, still works, no video mess-up after s2ram resume. I guess
we can close this regression for -rc6 now. I'll test it again after
Linus release the next update.

Thanks for the patch. Great work!

Jeff.
