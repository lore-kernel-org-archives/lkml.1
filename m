Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZA2ETU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZA2ETU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZA2ETK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:19:10 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:19639 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZA2ETJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=exjwTdh6JYGnNmwszHIRVUPCBU+JKQ8REmd/DOhjH17BMUNV43m17B0Gj+Myz6O1q9
         q4qyNwtPGA/6kwslAycbRCu1qZj+m2QQT1M2CNBrkcuQ74D4msT2QTULawD0WZm607y8
         lZiiniNZgeZPC1LcsCo4nyERwD/KoWwScpQII=
Message-ID: <49812E3B.6050106@gmail.com>
Date: Wed, 28 Jan 2009 20:19:07 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: macbook pro radeon suspend issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No sure if there is a bug report already or not.
For the macbook pro(ATI chipset) suspend is broken.
As for kernel version: latest git.
Last week(before LCA, and during the week, since being no merges.)
the system would wakeup, show a black screen and sit there. Now
after a couple of merges have been completed The system wakes up,
but instantly reboot's.

I tried to supply any info(ohci1394_dma) when the wakeup occurs, but had 
no response
for some reason or another.
I can try and do a bisect, the only problem
I have though, is I never labeled good/bad commits(forgot how too);

In any case If I'm in an urgent need, of having  to suspend
the system(not in anytime soon at the moment),
then Ill just revert kernels to one that I know works.     :^)

regards;

Justin P. Mattock
