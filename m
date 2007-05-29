Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXE2GBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXE2GBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXE2GBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:01:12 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:6952 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751521AbXE2GBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:01:11 -0400
Message-ID: <465BC19F.5070309@interia.pl>
Date: Tue, 29 May 2007 08:01:03 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070524)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 829f6acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  Hi!
>>
>> A lot of "NOHZ: local_softirq_pending 08" messages (about 100) and
>> then suddenly stoped to show. I have 2.6.21.1. I checked .2 and .3
>> changelogs but I don't see anything about this message.
>> What does it mean?
>>
>> Is "08" IRQ number?
>>   8:          2    XT-PIC-XT        rtc
>>
>> Please CC me.
> Does this patch [ http://lkml.org/lkml/2007/5/22/35 ] helps you fix it ?
> 
> Regards 
> Ananitya

Thanks. Looks like it will.

Regards
Rafa³



----------------------------------------------------------------------
Ile masz w domu niepotrzebnych rzeczy?
Wymien sie z sasiadami >> http://link.interia.pl/f1a93


