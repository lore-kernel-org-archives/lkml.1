Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZACGmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZACGmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 01:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZACGmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 01:42:07 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:64186 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZACGmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 01:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D+6LS2/KopMjWe52UKY7X1WQZOEN1Dq70brougnlXiJ/lmUVKBx3KOoR8Gm26cLhwz
         c8gUbLC/PlpNCCh4DErDge8+3kKpjrnSqxMj08znaCLlUdDVPV+HZZE5xetNfR5L56OL
         +QGqeslA/T4F1nWtx4KHfk2QIrdg4HKiURkyY=
Message-ID: <91b13c310901022242y59e05c39ycc9183a5595abd0@mail.gmail.com>
Date: Sat, 3 Jan 2009 14:42:01 +0800
From: "=?UTF-8?Q?Cheng_Renquan_(=E7=A8=8B=E4=BB=BB=E5=85=A8)?=" 
	<crquan@gmail.com>
To: "Alasdair G Kergon" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] dm-target: target_type improvements
Cc: "device-mapper development" <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090102181215.GF11060@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
	 <20090102181215.GF11060@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n036gLwM020740

On Sat, Jan 3, 2009 at 2:12 AM, Alasdair G Kergon <agk@redhat.com> wrote:> On Fri, Dec 19, 2008 at 12:19:42PM +0800, crquan@gmail.com wrote:>> From: Cheng Renquan <crquan@gmail.com>>> 3. totally remove tt_internal;>> The 3rd patch may be controversial,>> But I still think it's worth it:>> Well now that it's down to just one field for linking items I'm inclined to> agree that it's OK.>> Do you (or anyone else) have any interest in creating and testing similar sets> of patches for the other parts of device-mapper that use the same construction?
I just came across the device-mapper code and made the patches onemonth ago, I want to know you (dm-dev)'s attitude toward this type ofstruct reconstruction. Now I know it and can do more.
>> Alasdair> --> agk@redhat.com
BTW, why you set Reply-to field to my email address? Maybe an accidentof your mail client?
-- Cheng Renquan (ç¨‹ä»»å…¨), Shenzhen, ChinaGroucho Marx  - "I was married by a judge. I should have asked for a jury."ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
