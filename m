Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZCLDrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZCLDrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZCLDr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:47:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19040 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZCLDr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nlZ4/kvI0TbBviuYAESlgD71i2+SWTec4Udkv3KkhIvmweqCCgcy372mAx+xj9oj2T
         o8CNy1rbXUwAWjxOehWigk6RQ7ar2LjbHggT5ER/yFF9fUrkELVToR9WojnJ2UJdrb5G
         MjQi1GCLZ2EIcb4YlDvzaMKo7EHFGsFbjN+Fw=
MIME-Version: 1.0
Date: Wed, 11 Mar 2009 20:47:23 -0700
Message-ID: <dd18b0c30903112047o3995e0as4a86025be7100f88@mail.gmail.com>
Subject: suspend successful with radeon
From: Justin Mattock <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending this to you to let
you know that (uswsusp)
s2ram works with radeon; kernel:
2.6.29-rc7-00004-gc6504647.

to my surprise a minimal install as well
libx86emu,libx86 only
no directfb, splashy, etc..

was receiving a black screen a few weeks ago
but either there was a commit that fixed this,
or it was the permission on
/dev/console that I had set wrong.

either way it works
("thumbs up"), now to have acpid
execute this when the lid is closed.

regards;
-- 
Justin P. Mattock
