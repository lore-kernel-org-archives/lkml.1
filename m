Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYI3LtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYI3LtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYI3LtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:49:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:6030 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYI3LtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lv7xdZMWGCPo20bSX2cSukSuuMOq3SJfpNH99LtKP0GyFx06fmCpQEhtIqOcRW/xbd
         dW8IsyVnVVRpijQ/dYAwXxiN062S6CWiZIDNcQ10AzavTUS7x6q2pWCzoMl1e6WQghQU
         3Gkjjl+OYwMxMLB5ac9EenNpe8oqVGAt1IVJQ=
Message-ID: <48E211D7.8090304@gmail.com>
Date: Tue, 30 Sep 2008 20:47:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Todor Gyumyushev <todor@saturnosoft.biz>
CC: =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>,
       Jens Axboe <jens.axboe@oracle.com>, Albert Lee <albertcc@tw.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: bug report
References: <48DA0B39.5050401@saturnosoft.biz>	 <1222274317.14959.4.camel@odie.local>  <48DA7F1E.5030508@saturnosoft.biz> <1222280712.14959.14.camel@odie.local> <48E0311F.2030907@gmail.com> <48E09223.4000807@saturnosoft.biz>
In-Reply-To: <48E09223.4000807@saturnosoft.biz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todor Gyumyushev wrote:
>> Hmm... This shouldn't happen.  Can you please attach full kernel log
>> including the boot messages?
>>
>> Thanks.
>>
>>   
> Hi, here is attached the full kernel log.
> It seems something is happening with ath5k module ?

Does the problem occur w/o ath5k?  I don't really see how ata_piix can
trigger the WARN_ON().

Thanks.

-- 
tejun
