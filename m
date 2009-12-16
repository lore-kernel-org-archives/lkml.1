Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbZLPGl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbZLPGl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932550AbZLPGl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:41:58 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40111 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbZLPGl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:41:57 -0500
Message-ID: <4B288131.2050306@in.ibm.com>
Date: Wed, 16 Dec 2009 12:11:53 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Next] CPU Hotplug test failures on powerpc
References: <4B2224C7.1020908@in.ibm.com> <7b6bb4a50912152225p4f5dde13re83c439407c16eaf@mail.gmail.com>
In-Reply-To: <7b6bb4a50912152225p4f5dde13re83c439407c16eaf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote:
> Does this testcase hotplug cpu 0 off?
>   
No, i don't think so. It skips cpu0 during online/offline
process.

thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

