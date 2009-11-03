Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZKCXym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZKCXym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZKCXyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:54:41 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49557 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZKCXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:54:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=CXxmwUAagb1/Ftiees+jvNuyssBgRr827f5uO7W+gGKgdO4ndM8u30n1r+mDXdYvS2
         xxw9dVi5xZ+q5SVvGFth3nnZoq/HKAczMmOowO3J3f3cxF2y+PFq6kB+N0fR+MqtcA+E
         qUxBdLsKW0hN7ml0QX/n9MwVkSy7B5HpVc9Bg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Wed, 4 Nov 2009 00:52:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <200911032334.40547.bzolnier@gmail.com> <20091103234835.3042f7b5@lxorguk.ukuu.org.uk>
In-Reply-To: <20091103234835.3042f7b5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911040052.28323.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 00:48:35 Alan Cox wrote:
> > > Yeah I know that. But like I said, I still needed to get around to do that,
> > > and I am very happy you were interested in fixing it.
> > 
> > Lets make one thing clear: YOU SHOULD BE THE ONE FIXING IT.
> 
> Really - you have a service and support contract with Ivo.. no i thought
> not.

Just today I got PM from somebody complaining to me about non-working
pata_pdc2026x_old (pdc202xx_old works fine for him) simply because
I fixed some bug there some time ago....

Problems are publicly know -- do you want bz# from Debian, SuSE or Red Hat?

Wait.. unfortunately I also don't have support contract with you..

-- 
Bartlomiej Zolnierkiewicz
