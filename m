Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXB0QZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXB0QZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXB0QZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:25:29 -0500
Received: from il.qumranet.com ([82.166.9.18]:45746 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXB0QZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:25:28 -0500
Message-ID: <45E45AFE.8060501@argo.co.il>
Date: Tue, 27 Feb 2007 18:23:26 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: list.h , list_head and C++
References: <1172493644.311389.243780@8g2000cwh.googlegroups.com> <fa.K8OHlwttPU4TDDzMegRRFAIJrxw@ifi.uio.no> <fa.9RVekJKqUMy1lb5hfYQYDK8VxnE@ifi.uio.no> <1172571563.228792.208610@h3g2000cwc.googlegroups.com> <45E44165.4060608@shaw.ca>
In-Reply-To: <45E44165.4060608@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> remi.chateauneu@gmail.com wrote:
>> On Feb 26, 2:26 pm, Robert Hancock <hanco...@shaw.ca> wrote:
>>> remi.chateau...@gmail.com wrote:
>>>> My C++ program needs an intrusive list, possibly with RCU
>>>> capabilities.The data structurelist_head, defined in /usr/include/
>>>> linux/list.h , fits perfectly these needs.
>


I believe boost has a C++ intrusive list, which unlike the kernel's is 
completely typesafe.



-- 
error compiling committee.c: too many arguments to function

