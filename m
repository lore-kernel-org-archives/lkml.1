Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZDHLGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZDHLGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZDHLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:06:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:51037 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZDHLGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ovGPc9sWpZQVQe4VyAoNKW+XU4K1VlLrq8lTJzzZihIToR8y71q5Tq743TrAgugxeq
         lkTyTe5UoDzyvPxVAzzJvy5HfVjA1mJcelMzt1+0fJCsZAtwF6Qk/HK0D1Fvn0zYs/O/
         RqG181gqUWIdisXwaoUev2y3XbSD0lIjMPAkM=
MIME-Version: 1.0
In-Reply-To: <5a4c581d0904080351m6811ab81i59c9bc1043071d3@mail.gmail.com>
References: <208cbae30904080338x749800b0o392886ab023018b6@mail.gmail.com>
	 <5a4c581d0904080351m6811ab81i59c9bc1043071d3@mail.gmail.com>
Date: Wed, 8 Apr 2009 15:06:28 +0400
Message-ID: <208cbae30904080406j69afbc8dg1d9011359dbdb396@mail.gmail.com>
Subject: Re: commit "ACPI: battery: asynchronous init" brokes my boot up 
	process
From: Alexey Klimov <klimov.linux@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 2:51 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> On Wed, Apr 8, 2009 at 12:38 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>> Hello,
>>
>> I don't know if i do right thing creating this letter but looks like
>> this commit 0f66af530116e9f4dd97f328d91718b56a6fc5a4 "ACPI: battery:
>> asynchronous init" brokes my boot up process. My machine is pentium-m
>> cpu, Gentoo, gcc 4.3.3-r2.
>
> Vegard Nossum posted a patch that fixes this problem, it's
>  currently applied in Len Brown's tree so it should soon
>  appear in the mainline kernel:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0904.0/03127.html

Oh, i applied this patch and it works fine.
Thanks for letting me know :)

-- 
Best regards, Klimov Alexey
