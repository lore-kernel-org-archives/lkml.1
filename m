Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZFGQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZFGQyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZFGQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:54:12 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45369 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZFGQyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e0kWJyCjfeQq+pAcWxe5STPB/JHHkR9KQilwnyzTWw9bgMBK/Ba30svdf6xC4nfb4n
         mhw74mnM2nrPFeE2TF6BYgGAPOT/U4Y9NlPK3pdMfORFY4xlDOtg1iueSjUEk3O1lpAE
         NscadzkFnUa8tvid+dPFCzZQHgRRjJJfZH9bE=
MIME-Version: 1.0
In-Reply-To: <200906071744.23629.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	 <200906071657.49513.bzolnier@gmail.com>
	 <1244387931.8262.24.camel@mulgrave.site>
	 <200906071744.23629.bzolnier@gmail.com>
Date: Sun, 7 Jun 2009 19:54:08 +0300
X-Google-Sender-Auth: 4062c53641cfc7d0
Message-ID: <84144f020906070954p54cdfee4y62a51795be10b0d0@mail.gmail.com>
Subject: Re: [git pull] IDE fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Sun, Jun 7, 2009 at 6:44 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> Honestly, this should be solved on technical basis by somebody posting
> needed libata patches instead of attempts to slow down IDE fixes.

Nobody is "slowing down" IDE fixes here. Linus explicitly said that
-rc8 is the last release candidate and the next one is going to be
-final. There's absolutely _no way_ this series is appropriate at the
very end of a release cycle.

                         Pekka
