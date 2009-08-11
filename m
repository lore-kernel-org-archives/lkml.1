Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZHKVSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZHKVSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZHKVSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:18:48 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:63210 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZHKVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=PR+Osb2eDRfBmLKdeNRjlts9bvAu/C42Ce/ngozaot8AWlQQ0j5w9NB8THmM7XiA4p
         +MR+nZPngh+WijMnI2bsviWRAWHa6+azjuvSm5D8+GWTrYTqYSy+7YCP4SQsk4N3iBi/
         rmRqYu5Ck28B4vPbaxRcUDr93i3L/XKJh8ekg=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 11 Aug 2009 14:18:28 -0700
Message-ID: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com>
Subject: Typedef removal tool
To: devel@driverdev.osuosl.org
Cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone know if there is a typedef removal tool? When porting drivers
this needs to be done quite often.

FWIW I've started porting some driver and have come across some tools,
or written my own scripts, which have helped. Using spatch to port a
driver was such a tool I explored. I think I'll try to put together
some info on the driver project wiki for this. typdef removal tool
would still be neat.

  Luis
