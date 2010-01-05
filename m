Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172Ab0AEIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0AEIab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009Ab0AEIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:30:31 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:52582 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AEIaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:30:30 -0500
Message-ID: <4B42F8AF.3020304@bwalle.de>
Date: Tue, 05 Jan 2010 09:30:39 +0100
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Venkappa Mala <Venkappa.Mala@lntinfotech.com>,
       "rmk+lkml@arm.linux.org.uk" <rmk+lkml@arm.linux.org.uk>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux kernel crash dumps for ARM
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com> <m17hrx9lgo.fsf@fess.ebiederm.org>
In-Reply-To: <m17hrx9lgo.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
OpenPGP: id=DDAF6454
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.01.2010 06:20, schrieb Eric W. Biederman:
>>
>> 3) In lkcd, netdump,diskdump, mini kernel dump and kdump/kexec tools,
>>
>>    - which is the best choice for ARM or are there any best crash
dump tool for ARM?

LKCD is more or less dead (in favour of kdump) on any plattform. It
doesn't work with recent kernels.


Regards,
Bernhard
