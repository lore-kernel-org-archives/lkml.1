Return-Path: <linux-kernel-owner+w=401wt.eu-S934710AbZDJJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710AbZDJJxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZDJJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:53:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:23489 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZDJJxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=fZsufW5Ddt8DJzaozdSJvZcIEu16Vfd5Cuf64ZCh6Rp/UoW/ZdFxmQCH6oyH2MkAJS
         tpyGZh+csWVxQxhZBgDWKvWtnOmfVwAPRCdT4D7hnpXhDPUVLMJ2ZjZn7wwfhyD3Oqrd
         GMIP/KL28zMRi4FcbEkxCPHkZoblBz3X+F7XY=
MIME-Version: 1.0
From: Kim Kyuwon <chammoru@gmail.com>
Date: Fri, 10 Apr 2009 18:52:47 +0900
Message-ID: <4d34a0a70904100252j635a1ed6ydc402a79ea1a2ce8@mail.gmail.com>
Subject: [PATCH 0/3] leds: leds-bd2802 fixes
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

It was nice that I could add my driver(leds-bd2802.c) to mainline.

I'm sending a few patches that fix some errors and add new features

your comments appreciated.

 drivers/leds/leds-bd2802.c |   96 ++++++++++++++++++++++++++++++++++----------
 1 files changed, 75 insertions(+), 21 deletions(-)

Regards,
-- 
Kyuwon (±Ô¿ø)
