Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbXEZMux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbXEZMux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 08:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXEZMur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 08:50:47 -0400
Received: from kuber.nabble.com ([216.139.236.158]:43250 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbXEZMuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 08:50:46 -0400
X-Greylist: delayed 1399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 May 2007 08:50:46 EDT
Message-ID: <10815949.post@talk.nabble.com>
Date: Sat, 26 May 2007 05:27:26 -0700 (PDT)
From: Arunachalam <arunachalamp@huawei.com>
To: linux-kernel@vger.kernel.org
Subject: epoll,threading
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: arunachalamp@huawei.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

I want to know in detail about , what the events (epoll or /dev/poll or
select ) achieve in contrast to  thread per client.

i can have a thread per client and use send and recv system call directly
right? Why do i go for these event mechanisms?

Please help me to understand this.


Thanks in advance,
Arunachalam
-- 
View this message in context: http://www.nabble.com/epoll%2Cthreading-tf3820388.html#a10815949
Sent from the linux-kernel mailing list archive at Nabble.com.

