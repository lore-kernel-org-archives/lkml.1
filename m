Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYG1RGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYG1RGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbYG1RFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:05:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:36928 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbYG1RFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wErpyKa9Qu1zgGDcu49wMzBtKpq5gVfzg2RvgbaPvJWZo+Cc9fXoBajXVdazC7uXDr
         eDnAGteQoV26xh+3Ha1oOdWpHrq3uraW9F+e+PqKd2JwXAiofXcSb8oOko2SgA41nJ5v
         LG7ZXGaSuJo1CuX5vkvQPl23Dit1NK3RkE4Yg=
Message-ID: <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
Date: Mon, 28 Jul 2008 13:05:48 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: 463 kernel developers missing!
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <488DF9CF.8020408@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <488DF9CF.8020408@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 28/07/08 15:45, Jon Smirl wrote:
>
> > Here's a new .mailmap file for the kernel that cleans up the horrible
> > mess of names and email addresses in the log.  To use it put it at the
> > root of your kernel tree and type 'git shortlog'. Before the clean up
> > there were 4,284 developers, after 3,821. There are 5,051 unique
> > emails.
> >
> > The mailmap file contains all email addresses that have been used to
> > submit patches to the kernel. Don't freak out about your email address
> > being in the file, if it is in the file it is already in Google since
> > the kernel log is already in Google.
> >
>
>  Just because anyone can grep the kernel log for email addresses [to send
> spam to], doesn't mean that you need to do it for them.

You need to be in the file since you have submitted patches using three aliases.

>  Please read git-shortlog(1) and then remove me from this file because it
> won't change anything.
>
>  --
>  Simon Arlott
>


-- 
Jon Smirl
jonsmirl@gmail.com
