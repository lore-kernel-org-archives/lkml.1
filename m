Return-Path: <linux-kernel-owner+w=401wt.eu-S1751699AbZHCEb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbZHCEb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 00:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZHCEb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 00:31:57 -0400
Received: from kuber.nabble.com ([216.139.236.158]:58514 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZHCEb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 00:31:56 -0400
Message-ID: <24785241.post@talk.nabble.com>
Date: Sun, 2 Aug 2009 21:31:54 -0700 (PDT)
From: Nirav Rabara <nirav.rabara@matrixtelesol.com>
To: linux-kernel@vger.kernel.org
Subject: File System problem with 2.6.27/28
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: nirav.rabara@matrixtelesol.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am using at91sam9263, 32MB NOR flash, 32MB RAM with Linux kernel 2.6.28/27. 
I am facing a problem after file system mounting(JFFS2).
Kernel is getting crash after filesystem mounting.

But, the same filesystem work with 2.6.22. I am able to get Login prompt I
don't understand what's wrong with 2.6.28/27 
with linux kernel 2.6.22 and we can get loging promp.

Log for kernel 2.6.27 http://www.nabble.com/file/p24785241/2.6.27.TXT
2.6.27.TXT 
kernel configuration for 2.6.27 
http://www.nabble.com/file/p24785241/2.6.27.config 2.6.27.config 

Log for kernel 2.6.22 http://www.nabble.com/file/p24785241/2.6.22.TXT
2.6.22.TXT 
kernel configuration for 2.6.22 
http://www.nabble.com/file/p24785241/2.6.22.config 2.6.22.config  

Can anybody suggest why it's happening?



-- 
View this message in context: http://www.nabble.com/File-System-problem-with-2.6.27-28-tp24785241p24785241.html
Sent from the linux-kernel mailing list archive at Nabble.com.

