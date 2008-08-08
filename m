Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYHHK4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYHHK4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYHHK4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:56:37 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:35394 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYHHK4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OQOZMKafU0SNK+wwo4hHLbJgcTXeuJumZaHqKQkYcEIywOrLANLxiZ++NvYTUDgcow
         FXKJAqMO21cdyIYunk2TudB4k83c2ZqMQzYwk7BoMLe+X+Hnh1AjP7G2AC9fceIHD/71
         rGBzeaKdZcd/gEpSD0vfOaw8yxQ2DgVrFwGLc=
Message-ID: <a4423d670808080356r6573102am8a1eb9dcc83910c8@mail.gmail.com>
Date: Fri, 8 Aug 2008 14:56:35 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: mikpe@it.uu.se, kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080808.033811.129671951.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670808080231nc4d5e25q6636fe8ff090b84@mail.gmail.com>
	 <20080808.024024.205614839.davem@davemloft.net>
	 <a4423d670808080314weed9178o9f9ef52803a68501@mail.gmail.com>
	 <20080808.033811.129671951.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 David Miller <davem@davemloft.net>:
>> Yes, I applied it manually on top of 2.6.27-rc2-0166
>
> And then the problem goes away right?
>
No, It hangs in the same way, right after
console handover: boot [earlyprom0] -> real [tty0]
