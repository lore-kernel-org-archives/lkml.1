Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXESNRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXESNRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbXESNRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:17:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38117 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757388AbXESNRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:17:16 -0400
Message-ID: <379580628.01003@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 19 May 2007 21:17:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 9/9] readahead: remove the old algorithm
Message-ID: <20070519131713.GA6510@mail.ustc.edu.cn>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224819.420933490@mail.ustc.edu.cn> <20070519121855.GC25563@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519121855.GC25563@one.firstfloor.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 02:18:55PM +0200, Andi Kleen wrote:
> On Thu, May 17, 2007 at 06:48:01AM +0800, Fengguang Wu wrote:
> > Remove the old readahead algorithm.
> 
> FWIW - i read the complete patchkit. While I'm not a particular expert
> on that code i didn't see anything I didn't like

Thank you.

Wu

