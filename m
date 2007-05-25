Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbXEYKCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbXEYKCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXEYKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:02:44 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:49438 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXEYKCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:02:43 -0400
Message-ID: <4656ACB3.3060707@yahoo.fr>
Date: Fri, 25 May 2007 11:30:27 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       efault@gmx.de, kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com>
In-Reply-To: <20070525074500.GD6157@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri a écrit :
> Can you repeat your tests with this patch pls? With the patch applied, I am
> now getting the same split between nice 0 and nice 10 task as CFS-v13
> provides (90:10 as reported by top )

Yep, this fixes the problem for me too.

Thanks.

-- 
Guillaume
