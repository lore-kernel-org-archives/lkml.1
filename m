Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXAaRPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXAaRPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030312AbXAaRPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:15:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:30083 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXAaRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:15:48 -0500
In-Reply-To: <p73abzzpo75.fsf@bingen.suse.de>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Date: Wed, 31 Jan 2007 09:15:02 -0800
To: Andi Kleen <ak@suse.de>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2007, at 12:58 AM, Andi Kleen wrote:

> Do you have any numbers how this compares cycle wise to just doing
> clone+syscall+exit in user space?

Not yet, no.  Release early, release often, and all that.  I'll throw  
something together.

- z
