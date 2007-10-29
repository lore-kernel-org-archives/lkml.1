Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbXJ2Kv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbXJ2Kv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXJ2Kvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:51:49 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52530 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXJ2Kvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:51:48 -0400
Message-ID: <4725BAF1.5010006@bx.jp.nec.com>
Date: Mon, 29 Oct 2007 19:50:25 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/2] fix typo in SubmittingPatches
References: <47218DBC.8070404@bx.jp.nec.com>	<47218E80.50700@bx.jp.nec.com> <20071026205009.24ec2d83.randy.dunlap@oracle.com>
In-Reply-To: <20071026205009.24ec2d83.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> -Once significant exception is when moving code from one file to
>> +One significant exception is when moving code from one file to
>>  another in this case you should not modify the moved code at all in
>>  the same patch which moves it.  This clearly delineates the act of
>>  moving the code and your changes.  This greatly aids review of the
> 
> That first sentence is still broken.  It should be more like this,
> with either a ":" or ";" or " -- " between clauses:
> 
> One significant exception is when moving code from one file to
> another -- in this case you should not modify the moved code at all in
> the same patch which moves it.

Tahnks for your point.
I will fix this sentence as above.

-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com
