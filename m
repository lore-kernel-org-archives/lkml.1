Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYJGJl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYJGJl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYJGJlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:41:51 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53746 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYJGJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:41:50 -0400
Message-ID: <48EB2EDF.5000605@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2008 15:11:51 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
       svaidy@linux.vnet.ibm.com, davej@codemonkey.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
 in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan> <4860BB8E.2070505@linux.vnet.ibm.com> <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan> <48638906.4090308@linux.vnet.ibm.com> <87y74l4scd.fsf@skyscraper.fehenstaub.lan> <87fxqp7nye.fsf@skyscraper.fehenstaub.lan> <4871E657.3040403@linux.vnet.ibm.com> <87d4lqq7ec.fsf@saeurebad.de> <487300B1.4040300@linux.vnet.ibm.com> <877ibukn8k.fsf@saeurebad.de> <1216215897.1652.24.camel@lappy.programming.kicks-ass.net> <48A145FA.2030803@linux.vnet.ibm.com> <8763q53ot0.fsf@skyscraper.fehenstaub.lan> <87y73129ik.fsf@skyscraper.fehenstaub.lan>
In-Reply-To: <87y73129ik.fsf@skyscraper.fehenstaub.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any updates on this bug. Thanks in advance for your coordination.

Johannes Weiner wrote:
>> I have not yet looked at cpufreq_conservative...
>>
>> Thanks for your patience and insistence,
>>
>> 	Hannes
Thanks and Regards
R.Nageswara Sastry
