Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYJaUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYJaUat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYJaUak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:30:40 -0400
Received: from gw.goop.org ([64.81.55.164]:59013 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYJaUaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:30:39 -0400
Message-ID: <490B6AE8.3040700@goop.org>
Date: Sat, 01 Nov 2008 07:30:32 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu> <490AE820.1010301@goop.org> <20081031165334.GA10468@linux-os.sc.intel.com>
In-Reply-To: <20081031165334.GA10468@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> No. I am referring to Xen hypervisor code fix recently done by the Xen
> team in the Intel.
>
> http://xenbits.xensource.com/xen-unstable.hg?rev/50170dc8649c
>   

Ah, yes, OK then.

    J
