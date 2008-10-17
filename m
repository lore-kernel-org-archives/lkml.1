Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYJQSTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYJQSTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYJQSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:19:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20534 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYJQSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:19:08 -0400
Message-ID: <48F8D6F6.2050701@oracle.com>
Date: Fri, 17 Oct 2008 11:18:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: Re: [Bug #11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.0r.j675IB@wind> <48F2718E.6010803@oracle.com>
In-Reply-To: <48F2718E.6010803@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.26.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
>> Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
>> Submitter	: rdunlap <randy.dunlap@oracle.com>
>> Date		: 2008-08-21 5:52 (45 days old)
>> References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
>> 		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
>> Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
>> 		  James Bottomley <James.Bottomley@hansenpartnership.com>
> 
> Also happened with 2.6.27-git2.

and on 2.6.27-git7.
