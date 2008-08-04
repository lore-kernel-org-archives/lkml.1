Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYHDLSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYHDLSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYHDLSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:18:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:50289 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYHDLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y3PuJWMBhjeheEVehFyS2PbGGDhstWzqv9SUpmXV7+J+YGbBg3sLbx1AJdcaTUuh9x
         olZAoHUYLGX2gudRT5IzcwuhRkY1OkOgQLwo5TrDz0ye7lWOp0ZK5e5ZBmXFvryE2cz7
         V1400ZTj1BRTfXLK9LtIp1rvGpnlDfZ/f5yb8=
Message-ID: <9debc4410808040418u25f49436r4bb689f04f792564@mail.gmail.com>
Date: Mon, 4 Aug 2008 16:48:38 +0530
From: "Maxin John" <maxin.john@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: regarding mprotect() implementation in 2.6.26 kernel
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       ak@muc.de, mtk.manpages@gmail.com, shields@tembel.org,
       hirofumi@mail.parknet.co.jp
In-Reply-To: <cfd18e0f0808040341l1037ff77rc7c1b52f2bfe0dc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9debc4410807310315n4da5beafh853a71f532420e9a@mail.gmail.com>
	 <9debc4410807310324m4a76aaf5s253242e5cc2bb130@mail.gmail.com>
	 <4891D58E.1070308@goop.org>
	 <9debc4410808040319i3358a916v3b6cd534c0a0802c@mail.gmail.com>
	 <cfd18e0f0808040334p67b2c9f8g586fa984f6c96e55@mail.gmail.com>
	 <cfd18e0f0808040341l1037ff77rc7c1b52f2bfe0dc7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michael,


> So, after a quick search, it looks as though in kernels before 2.4.19,
> the EFAULT error resulted instead of ENOMEM for this case.  Does that
> sound right to you?

 Yes, I do agree with you. After Linux Kernel version 2.4.19 , the
ENOMEM error resulted instead of EFAULT in the mprotect().

Regards,

Maxin B. John
Bangalore, India
