Return-Path: <linux-kernel-owner+w=401wt.eu-S1946490AbXBIOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946490AbXBIOuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946494AbXBIOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:50:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55785 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946490AbXBIOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:50:38 -0500
Message-ID: <45CC8A2D.20509@garzik.org>
Date: Fri, 09 Feb 2007 09:50:21 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       David Ford <firefighterblu3@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
References: <45C6BCE5.90103@shaw.ca> <20070204213603.a5bce839.akpm@linux-foundation.org> <45C6C531.20508@shaw.ca> <20070204221741.63152cbe.akpm@linux-foundation.org> <523e55a00702081326j43de05e3hdd8cf35e946eae9@mail.gmail.com> <45CBE30D.5030006@nvidia.com> <20070209115821.GD10330@melchior.yamamaya.is-a-geek.org> <20070209120730.GA11911@melchior.yamamaya.is-a-geek.org>
In-Reply-To: <20070209120730.GA11911@melchior.yamamaya.is-a-geek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Tobias Diedrich wrote:
>> Ayaz Abdulla wrote:
>>> For all those who are having issues, please try out the attached patch.
>> Will try.
> 
> Does not apply cleanly against 2.6.20, is this one fixed up right?

It probably needs to be top of 2.6.20-git-latest or 2.6.20-rc6-mm3.

IOW, the forcedeth changes in question are not in 2.6.20, and you need 
to apply the patch on top of the latest batch of forcedeth changes.

	Jeff



