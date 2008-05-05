Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbYEENB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbYEENB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYEENA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:00:57 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:45854
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYEENA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:00:56 -0400
Message-ID: <481F0504.3010503@qumranet.com>
Date: Mon, 05 May 2008 16:00:52 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel@lists.sourceforge.net, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: s390 kvm_virtio.c build error
References: <20080503174716.GM5838@cs181133002.pp.htv.fi> <20080504192537.GA5499@osiris.boeblingen.de.ibm.com> <200805051429.47446.borntraeger@de.ibm.com>
In-Reply-To: <200805051429.47446.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
>> Hmm... this should help:
>>
>> ---
>>  drivers/s390/kvm/kvm_virtio.c |   40 
>>     
> +++++++++++++++++++++++-----------------
>   
>>  1 file changed, 23 insertions(+), 17 deletions(-)
>>     
>
> Thanks Heiko.
> I did a short test and it seems to work.
>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>
> This looks almost identical to Rusty's patch. Who is going to send this (or 
> Rustys) patch to Linus?
>   

I can, but tell me which one.  Also, the patch (Heiko's) needs a 
changelog entry and a signoff.

-- 
error compiling committee.c: too many arguments to function

