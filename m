Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYGOLqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYGOLqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYGOLqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:46:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:22978 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbYGOLqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ut8h7fDmPVaUchJLU5UA6jMpQA9mlXUt1MBRwyq8hFcuycOZ8L2gUoKFNucFJFM4uW
         Q1odLNkm4yqh3iSVXLBY2nNunhUmGDEUEW6aacJTv1t+Isf0r15+x8un1AQ6VQl+3KL4
         ryYb0QtAMjnUJ4NaBJpB/KEkmBe57zi1/om/0=
Message-ID: <b170af450807150446l555e9bbfx3f388d3ebe9cb11f@mail.gmail.com>
Date: Tue, 15 Jul 2008 13:46:29 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Toshiba - Documentation for Linux Developers
Cc: "Greg KH" <greg@kroah.com>, linux-acpi@vger.kernel.org, pavel@suse.cz,
       linux-kernel@vger.kernel.org
In-Reply-To: <487C865C.5060303@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <4855971D.90004@diamondcut.com.br> <20080616221443.GA760@kroah.com>
	 <b170af450807130654m2f800b10ybcba4b2c5c7cf329@mail.gmail.com>
	 <487A1534.3000307@diamondcut.com.br>
	 <b170af450807150017u248d4255i3800c10cb11df319@mail.gmail.com>
	 <487C865C.5060303@diamondcut.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6FBkkfq023034

2008/7/15, Renato S. Yamane <yamane@diamondcut.com.br>:> RafaÅ‚ MiÅ‚ecki wrote:>  > The newest version is packed for openSUSE fortunately. But it doesn't>  > for my notebook>> Try compile SVN version as commented in my last e-mail
OK, I tried version from SVN. Nothing changed :|

>  > dmesg is:>  > omnibook: Driver version 2.20070211-trunk.>  > omnibook: Unknown model.>>> Try force recognize with ectype parameter.>  #modprobe omnibook ectype=x
Sure, I tried every ectype between 1 and 15 before (omnibook frompackage) and now (version from SVN) again. I checked two files (whenexisted): lcd and temperature. Temperature (if file existed for forcedectype) was always 0 and lcd always had some random values. Insertingother values (1, 7) didn't change anything.
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
