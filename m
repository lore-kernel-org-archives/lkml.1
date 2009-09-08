Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZIHUMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZIHUMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZIHUMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:12:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:6759 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZIHUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:12:45 -0400
Message-ID: <4AA6BAA5.1080609@codemonkey.ws>
Date: Tue, 08 Sep 2009 15:12:21 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH v2 1/2] keep guest wallclock in sync with host clock
References: <1251902098-8660-1-git-send-email-glommer@redhat.com> <1251902098-8660-2-git-send-email-glommer@redhat.com> <20090908184159.GC19318@amt.cnet> <20090908193752.GH9013@mothafucka.localdomain> <20090908200004.GA20785@amt.cnet>
In-Reply-To: <20090908200004.GA20785@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
>>
>> Simple question: How do I run ntp in guests without network?
>>     
>
> You don't.
>   
Why bother doing this in the kernel?  Isn't this the sort of thing 
vmchannel is supposed to handle.  openvm-tools does this.

/me ducks

Regards,

Anthony Liguori

> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

