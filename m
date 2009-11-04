Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZKDC2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZKDC2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZKDC2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:28:36 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56888 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZKDC2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=TlEPofLrquc2lsm6SG4h43kfe5EKVnVogqBpsezdMSYfRIJAZxMKSIG1GVssv75F0z
         4xqq7cLyS/eCwNE14OEXjQQuwrb/oMkBVjOnPn/uNESw6JryDgFQn6jxabEQCvO6pN2G
         YAadDH4x0TEfiaZi5x7ZRZOGzIZWZ1Cx3IKC0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Wed, 4 Nov 2009 03:28:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <200911040046.54247.bzolnier@gmail.com> <646765f40911031733u1641c0dr5d4eec30031e7cea@mail.gmail.com>
In-Reply-To: <646765f40911031733u1641c0dr5d4eec30031e7cea@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200911040328.01997.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 02:33:52 Julian Calaby wrote:
> On Wed, Nov 4, 2009 at 10:46, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >> If you just want to continue with a hostile take-over of the rt2800
> >> maintainership, then please
> >> let us know that, so that we stop spending time on useless
> >
> > I fail to see why you see it as a hostile takeover.
> 
> Updating MAINTAINERS to replace the current developers with yourself
> can be considered to be a hostile act.
> 
> If you want this for your own personal tree, then keep the patch
> private - don't include it in pull requests, patch listings etc.

This is not pull request etc. but since the change in question has been
stirring needless controversies and distracting people from reading patches
it has been dropped for now.

-- 
Bartlomiej Zolnierkiewicz
