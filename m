Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbXKTWso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbXKTWso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761961AbXKTWsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:48:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:64949 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761575AbXKTWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=P2t7Lk++RzSzgWulpWAJ0x0iYCDthH15/lfisJLKGQ5oDpPr3cZRzK9IPAWApvaILR3Zpd8Sm/OBAq3dnNH4Jkqg7rNTbIcsMcZ6IlogutE2umJXY2Tv1aNXZi+3DmdfObL9zYiaCyjp4qtXl4ThRAon+/6JHLb0avg1KGg3Wgk=
Message-ID: <e85b9d30711201448r7b062akee8f311a56f5b1e0@mail.gmail.com>
Date: Tue, 20 Nov 2007 23:48:15 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> are you sure? The last -ck patch i can find is for .22:

>  http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/

> or have they been forward ported? (if yes, do you have an URL for that)

> (my guess is you used the 2.6.23.1 scheduler (CFS), so the improvement
> you felt on the laptop is relative to 2.6.23-vanilla in essence - which
> is good news.)

waninkoko over at forums.gentoo.org tries to forward port ck-patchset
as long as he can, as you can see
http://forums.gentoo.org/viewtopic-t-577970.html
(see later kamikaze-sources / zen-sources / klight-sources for more info)
ck-patchset & cfs has been an excellent combination so far ...

Cheers

Mat
