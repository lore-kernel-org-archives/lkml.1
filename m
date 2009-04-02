Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbZDBQDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbZDBQDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZDBQCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:02:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37559 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762385AbZDBQCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:02:49 -0400
Message-ID: <49D4E00B.8050904@redhat.com>
Date: Thu, 02 Apr 2009 18:55:55 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com,
       corbet@lwn.net, dmonakhov@openvz.org
Subject: Re: [PATCH 5/4] update ksm userspace interfaces
References: <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402053114.GF1117@x200.localdomain> <49D4BE64.8020508@redhat.com> <20090402155633.GD10392@x200.localdomain>
In-Reply-To: <20090402155633.GD10392@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Izik Eidus (ieidus@redhat.com) wrote:
>   
>> Is this what we want?
>>     
>
> How about baby steps...
>
> admit that ioctl to control plane is better done via sysfs?
>   
Yes
