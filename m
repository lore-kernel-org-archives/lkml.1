Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXLIWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXLIWnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXLIWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:43:11 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:9560 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbXLIWnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-rim-org-msg-ref-id:return-receipt-to:message-id:reply-to:x-priority:sensitivity:importance:to:cc:subject:from:date:content-type:mime-version;
        b=YbYWcSysivRec0K050TNwnVsodRRAMffjnT3FX7V7GItmd3dmEGdg1UGq2V8Q96C8hrKidsCdZwdwuGCgJA0NEYiGNL5ku0aY98nQlB7AZfPapNXLSK2MMEQ3NYfLbgftInVkythQ9mNYDadII49IZ1WmKcrX4p6r1mgIGG8l0o=
X-rim-org-msg-ref-id: 2003594310
Message-ID: <2003594310-1197240184-cardhu_decombobulator_blackberry.rim.net-1791217838-@bxe019.bisx.prod.on.blackberry>
Reply-To: parag.warudkar@gmail.com
X-Priority: Normal
Sensitivity: Normal
Importance: Normal
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
From: parag.warudkar@gmail.com
Date: Sun, 9 Dec 2007 22:42:39 +0000
Content-Type: text/plain
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>starts to sound like something is >turning off the clock during a >somewhat deeper C-state...

Sure may be - powertop is behind all this - if there wasn't long lasting deep c-state we wouldn't have this problem :) 

Actually I run powertop and disable things until the machine goes into around 5-6 wakeups per second. So what you said is quite likely.

Thanks for powertop.

Parag
Sent via BlackBerry from T-Mobile

