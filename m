Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbYGRWTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbYGRWTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760859AbYGRWSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:18:23 -0400
Received: from iona.labri.fr ([147.210.8.143]:47529 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761379AbYGRWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:18:22 -0400
X-Greylist: delayed 1634 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 18:18:21 EDT
Message-ID: <48811047.1030509@inria.fr>
Date: Fri, 18 Jul 2008 23:51:03 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Maciej Sosnowski <maciej.sosnowski@intel.com>, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, net-dev@vger.kernel.org
Subject: Re: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma
 driver
References: <20080714132215.26830.90819.stgit@linux.site>	 <20080714132349.26830.22215.stgit@linux.site>	 <487B6004.6090801@inria.fr> <e9c3a7c20807181116s49982f98p8d56a6e5e8264e6e@mail.gmail.com>
In-Reply-To: <e9c3a7c20807181116s49982f98p8d56a6e5e8264e6e@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
>>> Sleep time in self_test has been increased to 10ms
>>> since in some cases 1ms appeared not to be enough
>> Thanks Maciej, this helps a lot here.
>>
> 
> Can I interpret this as a "Tested-by" for the watchdog and/or the self_test fix?

The sleep time increase to 10ms has been tested for a while (and helps a
lot here).

I don't know about the watchdog yet.

Brice
