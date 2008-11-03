Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYKCXst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYKCXst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 18:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYKCXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 18:48:29 -0500
Received: from gw.goop.org ([64.81.55.164]:41537 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbYKCXs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 18:48:28 -0500
Message-ID: <490F8DC9.9000005@goop.org>
Date: Mon, 03 Nov 2008 15:48:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu> <490AE820.1010301@goop.org> <20081031165334.GA10468@linux-os.sc.intel.com> <490B6AE8.3040700@goop.org> <20081103101736.GI13671@elte.hu>
In-Reply-To: <20081103101736.GI13671@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok - so that makes it a v2.6.28 item i guess.
>   

The case Suresh is talking about was a fix to Xen itself, rather than on 
the kernel side, so it doesn't need to be a .28 issue on Xen's account.

    J
