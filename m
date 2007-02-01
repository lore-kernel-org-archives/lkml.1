Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbXBAWTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbXBAWTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXBAWTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:19:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:46571 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbXBAWTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:19:42 -0500
In-Reply-To: <20070201111307.GA24723@in.ibm.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de> <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com> <200701311821.59579.ak@suse.de> <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com> <20070201111307.GA24723@in.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4D9CAE22-C038-41C2-965F-48B7D38F0E02@oracle.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Date: Thu, 1 Feb 2007 14:18:55 -0800
To: suparna@in.ibm.com
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Wooo ...hold on ... I think this is swinging out of perspective :)

I'm sorry, but I don't.  I think using the EIOCBRETRY method in  
complicated code paths requires too much maintenance cost to justify  
its benefits.  We can agree to disagree on that judgement :).

- z
