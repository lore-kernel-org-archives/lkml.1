Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYHTImv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYHTImv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYHTImk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:42:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:33302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYHTImj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:42:39 -0400
Message-ID: <48ABD8D4.3020200@kernel.org>
Date: Wed, 20 Aug 2008 17:41:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Fabio Coatti <cova@ferrara.linux.it>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: SATA problems and fs corruption on recent kernels
References: <fa.PZ8V7KpfqpWoxUeVa4Sv6GFtUN0@ifi.uio.no> <48A0D44D.7010305@shaw.ca> <200808122224.39863.cova@ferrara.linux.it>
In-Reply-To: <200808122224.39863.cova@ferrara.linux.it>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 Aug 2008 08:42:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Coatti wrote:
> Yes, and the hardware problem is the first thing I thinked of, but I've 
> changed MB and cables, as well as bought a new disk. An I still get some I/O 
> errors, even on the new one.
> So, or I'm a bit unlucky to find several faulty disks in a row (it can be :) ) 
> or something unclear is going on. 
> The disk that suffers most lockups, after many tries, is the new one, the only 
> SATA-II drive.
> I'll keep stressing the HD trying to figure out what's going on, I'll even try 
> a new sata-II unit, to see if I've really picked a heap of faulty disks.

Heh... that's strange.  New power and new m/b and new disks don't solve
it?  Please let us know the test result.

Thanks.

-- 
tejun
