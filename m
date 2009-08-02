Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZHBH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZHBH4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZHBH4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 03:56:21 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:47295 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZHBH4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 03:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BVYhilkOw0ME+sMJq4HNxAdfkbcvnmpp0mnnaH8BIUgKxTyhA/Dp5d2Ar25WDjyaRc
         SHeee2/6t7zTIfS43iAx4x1FNZbc1hBiLW9oBgkzikg1GiCtuNN2X3pr/7DMK3CffDLU
         UGG5OPTIRXDaMSSusXi33x/2ZpbzmbESHwu78=
MIME-Version: 1.0
Date: Sun, 2 Aug 2009 15:56:20 +0800
Message-ID: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
Subject: mm/-next release on kernel.org web page?
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The last mm patchset is 2.6.28-rc2-mm1. We can not download -mm
patchset from kernel.org web page since the -next tree born.

Could you consider put mmtom release there just like before? And even
-next tree patchset? It will be more convenient for users who test
kernel just by downloading from web. Now it's impossible for them to
test these patchsets because they normally do not subscribe to lkml.


-- 
Regards
dave
