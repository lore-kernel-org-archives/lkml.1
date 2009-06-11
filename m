Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZFKOds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZFKOds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZFKOdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:33:41 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:33052 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZFKOdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pv/OyLNouvQbygQDYXq8ghLuU9wf26twfH38xIqV3URzb/iFpbyvCyPLVii9SRi07s
         IaUOyfWs71JCKlQ1P1Khwps31LpuvBRMLVDtV4V8ZjXYJeaT7k1vXPIXTyWStzBEsQek
         as91f8tvD6fAKPA831jLvy1znJn1adJ8R8tWs=
MIME-Version: 1.0
In-Reply-To: <20090611081012.GD8592@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	 <20090611081012.GD8592@elf.ucw.cz>
Date: Thu, 11 Jun 2009 16:33:36 +0200
Message-ID: <81b0412b0906110733i29c7cd21qe21dd8f467a91a3@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Alex Riesen <raa.lkml@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/11 Pavel Machek <pavel@ucw.cz>:
>
> Strange, I attempted downloading this overnight (285MB!) by
>
> git clone  --template=/data/l/clean-cg/ git://android.git.kernel.org/kernel/msm.git
>

I believe you need --reference, not --template. No wonder you had to download
complete repository anew.
