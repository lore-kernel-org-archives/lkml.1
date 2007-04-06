Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXDFS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXDFS2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXDFS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:28:37 -0400
Received: from www.nabble.com ([72.21.53.35]:58608 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXDFS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:28:36 -0400
Message-ID: <9876368.post@talk.nabble.com>
Date: Fri, 6 Apr 2007 11:28:36 -0700 (PDT)
From: abscis <abhay_gatech_in@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: Making external (alien) RAM cacheable
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: abhay_gatech_in@yahoo.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I have 1G physical memory on the system.  out of which only 200 MB is known
to the linux kernel.  Now I have some buffers in the other 824 MB of memory. 
These buffers would be inherently non cacheable because that memory is
unknow to the system.  I was wondering how can I include some of the buffers
in that memory in the page table so that they become cacheable.

Any inputs would be highly appreciated.

Thanks
Aby
-- 
View this message in context: http://www.nabble.com/Making-external-%28alien%29-RAM-cacheable-tf3538134.html#a9876368
Sent from the linux-kernel mailing list archive at Nabble.com.

