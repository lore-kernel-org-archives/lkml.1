Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZFVMGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZFVMGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZFVMFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:05:54 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:34609 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZFVMFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EbPVwrucE3BbA5DmKzSUFGObZbRfxAMVCD/8/ay7lrp7kCkLJ/x4f1C7y06y6hYlNE
         Y9HK5pY54HmnMT9w4fL1H+CNG28idui46sN4JAHedx1Ilz9V/osl+Chnrd+PSMjzf5q2
         ppz0bu5o2WSF4WlORtQaGNwlsdo9BU3ourWO8=
Message-ID: <4A3F73A0.1010005@panasas.com>
Date: Mon, 22 Jun 2009 15:05:52 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Amerigo Wang <xiyou.wangcong@gmail.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>	<4A3F4448.30502@panasas.com>	<20090622085735.GB6499@cr0.nay.redhat.com> <20090622205226.fee30ba8.sfr@canb.auug.org.au>
In-Reply-To: <20090622205226.fee30ba8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 01:52 PM, Stephen Rothwell wrote:
> Hi Amerigo,
> 
> On Mon, 22 Jun 2009 16:57:35 +0800 Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>> Stephan, could you please also do compiling tests for UML in your -next tree?
>>
>> Thanks!
> 
> I would be happy to do this, all I need is for someone to tell me how to
> do this given we have PowerPC hosts so our X86 compilers are cross
> compilers.

OK I'm not sure how to do that?

But just a plain PowerPC UML could be nice for a start. If it at all
works.

Thanks
Boaz

