Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXDFTvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXDFTvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXDFTvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:51:37 -0400
Received: from main.gmane.org ([80.91.229.2]:43342 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbXDFTvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:51:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [2.6.21-rc5-git1][KVM] exception on start VM
Date: Fri, 06 Apr 2007 15:53:00 -0400
Message-ID: <4616A51C.8030808@tmr.com>
References: <200703292201.l2TM1fO4005275@posidon.tmr.com> <460CADB8.9090607@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Bill Davidsen <davidsen@posidon.tmr.com>, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <460CADB8.9090607@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Bill Davidsen wrote:
>> Starting a VM for Win98SE:

[ debug snip info ]

> Known issue.  It will be a while before we can support the '95 family on 
> Intel as it makes heavy use of real mode.
> 
Thanks for the quick answer, I'll investigate other virtualization 
solutions.

> Please copy kvm-devel@lists.sourceforge.net on kvm issues, a per 
> MAINTAINERS.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

