Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbXISRPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbXISRPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbXISRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:15:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXISRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ibyJiZySHj66PvQBX739hyDHsIMmaBOOo7yXPXca5LuVgBWcIPFhSsWMM/SQ9t9LGTvelXsc8K7BGCc6cuWqb5Kr/dbT8goLD0GvdvA0gliCnk/zHJ4tRPv1G6dq53ew1LSsU/EDqUCvroZbhmzDG/+dYDvd0/P+JurwUy1bfCQ=
Message-ID: <e1d5030b0709191014s1a0f212aq55eae99c76136cd9@mail.gmail.com>
Date: Wed, 19 Sep 2007 22:44:58 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: "Xu Yang" <risingsunxy@googlemail.com>
Subject: Re: ramdisk
Cc: "Uli Luckas" <u.luckas@road.de>, LKML <linux-kernel@vger.kernel.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>
In-Reply-To: <ab40e9c0709050435y69cf04d6kfebf0e29faecb09d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com>
	 <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com>
	 <200709051007.41085.u.luckas@road.de>
	 <ab40e9c0709050422s413df8c9v4a4fcf6c2437d6b4@mail.gmail.com>
	 <ab40e9c0709050435y69cf04d6kfebf0e29faecb09d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xu,

   As far we have worked on it, the parameter to be passed is
"root=/dev/ram" and not "root=/dev/ram0". Atleast I used it to boot
the kernel on a U-Boot boot loader.

  I guess I can help you out. But I will need more details. But I
would like you to try "root=/dev/ram" first and let me know if its
working.

Midhun.
