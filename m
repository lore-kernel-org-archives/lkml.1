Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbXLNTQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbXLNTQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbXLNTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:15:49 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:54124 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbXLNTPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:15:48 -0500
Message-ID: <4762D651.50801@oracle.com>
Date: Fri, 14 Dec 2007 11:15:29 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] dio: falling through to buffered I/O when invalidation
 of a page fails
References: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>	 <475F32B0.20107@oracle.com> <1197658796.12368.1.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1197658796.12368.1.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If anyone has a testcase - I can take a look at the problem again.

I can try and throw something together..

- z
