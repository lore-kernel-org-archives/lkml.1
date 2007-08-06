Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXHFCFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXHFCFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXHFCE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:04:57 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:4239 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXHFCE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nX2oTcwP2TUJENa+mgmL+cLtcQQkxAR9P5He6QttyAV4fi+P4DGzPuEmo0JN4hTGHtVRCfghrriHoR4q2eMc0quQ/lQXMMVbEZiukSkLYS4rC/ZjZ4w2rQJxeaVvz9eb0DEeO6nDpbr9jL2xMTYwgVm/FgVkRJQFa/st5Nqva8o=
Message-ID: <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
Date: Sun, 5 Aug 2007 22:04:55 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [GIT PULL] Blackfin arch update for 2.6.23
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1186318969.16030.2.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186318969.16030.2.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> Bryan Wu (4):
>       Blackfin SPI driver: Initial supporting BF54x in SPI driver
>
> Michael Hennerich (11):
>       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
>       Blackfin arch: add peripheral resource allocation support
>       Blackfin arch: Add label to call new GPIO API
>       Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
>       Blackfin SPI driver: use new GPIO API and add error handling

i think this is the sort of thing Linus wants left for initial merge windows ?
-mike
