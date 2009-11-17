Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZKQLtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZKQLtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZKQLtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:49:20 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:63582 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZKQLtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jr+qzIUadmICjApXpy5jY56AjOrUVHMJZ3o9ZM838oCiMZ3AxkmdzT17EM7ZoebBpX
         /wJRzUEtkXerSm5cC7CgQNvc46D/gcVOtVDH2IrBXbQJO0oa/8sfvkoowsGvc1Ingggh
         U6EQM3N9MAI/FgLRDH+6sKPfYMUdv5bPJ7UMs=
Message-ID: <4B028DC0.2010907@gmail.com>
Date: Tue, 17 Nov 2009 06:49:20 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: huananhu@huawei.com, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
References: <20091117111454.GA8341@ff.dom.local>
In-Reply-To: <20091117111454.GA8341@ff.dom.local>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 17-11-2009 11:20, William Allen Simpson wrote:
>> David Miller wrote:
>>> Your patch is broken, please don't wate my time like this.
>>>
>>> + git apply --check --whitespace=error-all diff
>>> error: patch failed: drivers/net/ppp_async.c:36
>>> error: drivers/net/ppp_async.c: patch does not apply
>>>
>> What David may have meant, had he followed Documentation/ManagementStyle
>> or had any project management skills what-so-ever, is that you need to
>> follow Documentation/SubmittingPatches more carefully.
> 
> I think this time it was only about a missing tab ;-)
> 
In his inimitable inimical manner, comprehensively comprehensible. ;-)
