Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZLORoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZLORoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZLORoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:44:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51663 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZLORog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:44:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OlfvWuhrMlKa2Thm3SjBBiXUe6TG2nXpySUGDqb7BXUbYiLpx0CdoTNWisJ8QzpiWk
         7gtwSsOAcS5lKmm/JWBZsyYr9PnwXbIufSbXT7h/0tl4WP3kdbT1XbaRbdnK7kAi4JBJ
         AVqqee8sBvbrylfMbC3XsLK90rSUGCfy/NLW4=
MIME-Version: 1.0
In-Reply-To: <1260898610-25713-1-git-send-email-vapier@gentoo.org>
References: <1260898610-25713-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Dec 2009 12:44:14 -0500
Message-ID: <8bd0f97a0912150944h43b0f96fq80ba8579e6d27006@mail.gmail.com>
Subject: Re: Pull request blackfin.git (for-linus branch)
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:36, Mike Frysinger <vapier@gentoo.org> wrote:
> Mike Frysinger (47):
>      bfin-otp: add BF51x to the supported arch list
>  drivers/char/Kconfig                               |    2 +-

this pull request does include one change outside of the
arch/blackfin/ territory, but it's in that lawless drivers/char/ land
... it's a one line change to a Blackfin-specific char driver.  i hope
it's ok i sneak it in via my tree.
-mike
