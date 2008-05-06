Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbYEFOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbYEFOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYEFOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:39:11 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53522
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYEFOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:39:09 -0400
Message-ID: <48206D87.7080609@qumranet.com>
Date: Tue, 06 May 2008 17:39:03 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Adrian Bunk <bunk@kernel.org>, Carsten Otte <cotte@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: s390 kvm_virtio.c build error
References: <20080503174716.GM5838@cs181133002.pp.htv.fi>	 <20080504192537.GA5499@osiris.boeblingen.de.ibm.com>	 <200805051429.47446.borntraeger@de.ibm.com> <481F0504.3010503@qumranet.com> <1209992810.7089.15.camel@localhost>
In-Reply-To: <1209992810.7089.15.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Tue, 06 May 2008 17:39:04 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> I've added Heiko's patch to my patchqueue. But since this is
> drivers/s390/kvm this should go in over the kvm.git. See patch below.
>
>   

Thanks, I added this to my queue as well.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

