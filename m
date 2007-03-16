Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXCPODR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXCPODR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964796AbXCPODR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:03:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45366 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXCPODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:03:16 -0400
Message-ID: <45FAA39C.9050705@us.ibm.com>
Date: Fri, 16 Mar 2007 09:03:08 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070316083650.GA8525@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sun, Mar 11, 2007 at 03:53:12PM +0200, Avi Kivity wrote:
>   
>> This patchset updates the kvm userspace interface to what I hope will
>> be the long-term stable interface.  Provisions are included for extending
>> the interface later.  The patches address performance and cleanliness
>> concerns.
>>     
>
> Searching the mailing list I figured that as soons as the interface seems
> to be stable, kvm should/would switch to a system call based interface.
> I assume the userspace interface might still change a lot, especially if
> kvm is ported to new architectures.
> But the general question is: do you still plan to switch to a syscall
> interface?
>   

What benefit would a syscall interface have?

Regards,

Anthony Liguori

> -------------------------------------------------------------------------
> Take Surveys. Earn Cash. Influence the Future of IT
> Join SourceForge.net's Techsay panel and you'll get the chance to share your
> opinions on IT & business topics through brief surveys-and earn cash
> http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>
>   

