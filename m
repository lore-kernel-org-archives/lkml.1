Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbYERMdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbYERMdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYERMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:33:05 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:32910
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbYERMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:33:03 -0400
Message-ID: <483021FD.3040801@qumranet.com>
Date: Sun, 18 May 2008 15:33:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug #10643] s390 kvm_virtio.c build error
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.Y6.HtBMIB@albercik> <20080518122717.GB5577@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080518122717.GB5577@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Sun, 18 May 2008 15:33:01 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sun, May 18, 2008 at 01:13:55PM +0200, Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10643
>> Subject		: s390 kvm_virtio.c build error
>> Submitter	: Adrian Bunk <bunk@kernel.org>
>> Date		: 2008-05-08 14:05 (11 days old)
>> References	: http://lkml.org/lkml/2008/5/3/155
>> Handled-By	: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Patch		:  several nearly identical patches, KVM tree should bring one
>>     
>
> Still broken. Waiting for Avi's pull request.
>   

This was sent out a few minutes ago.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

