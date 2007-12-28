Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXL1HiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXL1HiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXL1HiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:38:03 -0500
Received: from pils.linux-kernel.at ([213.129.242.82]:21207 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXL1HiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:38:01 -0500
Message-ID: <4774A7B8.30104@linux-kernel.at>
Date: Fri, 28 Dec 2007 08:37:28 +0100
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Michal Schmidt <mschmidt@redhat.com>, Justin Banks <justinb@bakbone.com>,
       linux-kernel@vger.kernel.org
Subject: Re: kernel panic - help!?
References: <475FA716.2000105@linux-kernel.at>	 <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com>	 <20071212142436.GB16664@bleen.domain.actdsltmp>	 <20071212173753.5bf5bb5b@brian.englab.brq.redhat.com> <a8e1da0712121727m143fd036wd4762c1562b6dc24@mail.gmail.com>
In-Reply-To: <a8e1da0712121727m143fd036wd4762c1562b6dc24@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: lBS7bSWu017633
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2007 02:27 AM, Dave Young wrote:
> On Dec 13, 2007 12:37 AM, Michal Schmidt <mschmidt@redhat.com> wrote:
>> On Wed, 12 Dec 2007 07:24:36 -0700
>> Justin Banks <justinb@bakbone.com> wrote:
>>
>>>>> (2.6.9-55.0.9.ELsmp)
>>> -----^^^^^^^^^^^^^^^^^^
> 
> I'm so blind.
> 
>>> It's really really old :)
>> No, it's actually less than 3 months old kernel from RHEL-4 or CentOS.
> 
> Maybe, but the version number is old indeed.
> 
> BTW, Oliver Falk , the problem seems caused by sysfs readdir, it  was
> probably fixed already.  Please try latest kernel.

By latest you mean latest RHEL kernel, or latest upstream?

-of
