Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbXGFHP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbXGFHP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762632AbXGFHPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:15:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:33415 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762604AbXGFHPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=Snv3F7ZAfXljxd3fW9OpHfvE+5t0xHuKJK2Fn0PG14FSPO8l6DbplJnnBm94Fvy6qCFtb1vyh6sbzAi35CmrpJ0ZHsVABbb1McEGbq4hxd6bu55z2mMVcClGUW6g3GJXMjI8B0nvolE2raUdU86kIDV41KwFnz7wwQW1J4nkAbk=
Message-ID: <468DEC1B.6010301@gmail.com>
Date: Fri, 06 Jul 2007 12:45:39 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Gautam Singaraju <gautam.singaraju@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RSA support into kernel?
References: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com> <f8b2ccd40707051753v7cba58cfw1d3e0df5e4decc6d@mail.gmail.com>
In-Reply-To: <f8b2ccd40707051753v7cba58cfw1d3e0df5e4decc6d@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautam Singaraju wrote:
> Is there any attempt being made to provide software based RSA
> cryptographic support in kernel? I see that Linux supports
> Hardware based cryptographic devices (VIA Padlock ACE). How is the
> performance of such hardware? How well are these devices supported?
> -GS

i fail to see why the kernel should provide software RSA support? The
hardware support that you're talking about are device drivers for chips,
not a cryptographic interface.

-jb
-- 
Tact is the art of making a point without making an enemy.
