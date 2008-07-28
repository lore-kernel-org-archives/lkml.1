Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYG1Qu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYG1Qu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYG1Qrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:47:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:36396 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310AbYG1Qri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fau1mAMsLNkQBnpu+7634qMsWM0PO4eKEO3aITQdNvwR1valW+watUSH9iMBZ8SoIg
         lmDh0U1KaE+/EkOOHq9YZQ7hxDqupjdHU8aG3WiU3P35D80wIlyp6C6+ETBU/cgjogF/
         tQE5mjxBNiGUmBoYHBcYM9wokJbzIMo50T/wI=
Message-ID: <9e4733910807280947w5e259e11j6aa6da2fd64e4f8b@mail.gmail.com>
Date: Mon, 28 Jul 2008 12:47:37 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: 463 kernel developers missing!
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1217262018.6145.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <1217262018.6145.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Joe Perches <joe@perches.com> wrote:
> On Mon, 2008-07-28 at 10:45 -0400, Jon Smirl wrote:
>  > if you aren't in mailmap part of your commit
>  > needs to include a new entry for mailmap.
>
> Why?

So that we can validate against future misspellings of your name and
email address. It's all about doing validation and stopping the
errors. The current log has over 1,000 typos in the names and emails.
Getting rid of the typos makes it possible to generate clean
statistics.

If you're paranoid get a new gmail address for each commit. From
reading the list of authors I'd say we have about 10 paranoid people
out of 3,840.

>
>


-- 
Jon Smirl
jonsmirl@gmail.com
