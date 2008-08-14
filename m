Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYHNKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYHNKvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 06:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYHNKvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 06:51:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:49656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYHNKvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 06:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d1tvnj3qYxdin85r2W1dJAck2L5tFihtyagCJZJkS0AfJP045PtHk5GUJy1532C9cc
         gW8ONBzqo3krV8Id4PP9BqlOoWU9KeE7tiTAsbCmkXciiHi2H+0Z1Yfy/qbECAdLLPJU
         L2f7XMTvdAzw/LT0wZNmRE6Q5UL6vRK011DMo=
Message-ID: <a4423d670808140351g7129d899nfbc2796f6b30e86f@mail.gmail.com>
Date: Thu, 14 Aug 2008 14:51:11 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH -mm] fs.h: fix build error with !CONFIG_FILE_LOCKING
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       swhiteho@redhat.com, cluster-devel@redhat.com,
       "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20080814111934.6d68fa23@surf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080808223228.GC5093@orion> <20080814111934.6d68fa23@surf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7EApRdq013572

2008/8/14 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>:> Le Sat, 9 Aug 2008 02:32:28 +0400,> Alexander Beregalov <a.beregalov@gmail.com> a Ã©crit :>>> I am not sure it is a right way to fix it, please review.>> Commit 4a70917f881a38ae688c98be9396f0a38f559094>> (configure-out-file-locking-features) changed behaviour.>> I must admit that I'm quite confused by the commit you're referring to.> In which tree is it ?It was in rc1-mm1.
Thanksÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
