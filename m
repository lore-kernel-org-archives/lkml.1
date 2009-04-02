Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZDBHL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZDBHL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZDBHLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:11:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33673 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbZDBHLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:11:14 -0400
Message-ID: <49D464AF.1090308@redhat.com>
Date: Thu, 02 Apr 2009 10:09:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chris Wright <chrisw@redhat.com>
CC: Bert Wesarg <bert.wesarg@googlemail.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com,
       corbet@lwn.net, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4 alternative userspace] add ksm kernel shared memory
 driver
References: <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402054816.GG1117@x200.localdomain> <36ca99e90904012257j5f5e6e2co673ff2433d49b7b9@mail.gmail.com> <20090402055906.GH1117@x200.localdomain>
In-Reply-To: <20090402055906.GH1117@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
>> I can't find a definition for MADV_UNSHAREABLE!
>>     
>
> It's not there ;-)
>   

You were not able to share it with us?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

