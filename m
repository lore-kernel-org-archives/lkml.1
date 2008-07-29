Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYG2Tta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYG2Tta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYG2TtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:49:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:61875 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYG2TtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=aHP6vms8LA5cI2ofdtItYZDgsegD/3ai4SYx9qBETWFFYzPyqMnBuR4tfkFL5rtTNb
         kxKNOKpSHHZwKlQmrW4el1RD3j1WdOxM2h479szeSXBinr1lX65dmW8W0PGrWoKjJCfY
         QPDV6rW1HikeIAbZNWjlASQwaQ0W1FdZJ5sPc=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc1
Date: Tue, 29 Jul 2008 15:49:14 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291549.14502.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

It appears our section miss-match thing is back, from the build trace:
  MODPOST vmlinux.o
WARNING: modpost: Found 6 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

I'll go see if it will run now. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Reader, suppose you were an idiot.  And suppose you were a member of
Congress.  But I repeat myself.
		-- Mark Twain
