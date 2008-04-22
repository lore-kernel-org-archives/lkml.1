Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbYDVVE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbYDVVE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbYDVVEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:04:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:16680 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbYDVVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:04:48 -0400
Message-ID: <c913039c0804221404h5d387d61i9f1c2e1006c88c8d@mail.gmail.com>
Date: Tue, 22 Apr 2008 23:04:45 +0200
From: "Abdel !" <abdel@benamrouche.com>
To: linux-kernel@vger.kernel.org
Subject: unofficial linux-0.01-3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have released linux 0.01-3.3 on january 1, 2008.
And I often be asked 2 question :

the 1st was, "I can't build linux-0.01-3.3, why ?"
===================================

Well linux 0.01 was very well written, except 1 thing in the
Makefile :
To get file size of the kernel image, Linus Torvalds used the
following ( and ugly ) command :
"ls -l tools/system | grep system | cut -c31-37" which may be invalid
for you.

So the unofficial linux-0.01-3.5 ( which was released on the end of
January ) fix that and use
stat command instead. It should work on any computer.

by the way, linux 0.01 rocks !
a very small kernel, well writen, easy to understand and wich can do
real kernel job !
(  scheduler works, paging system was already implemented,  filesystem
worked in a different thread, and main syscall was already implemented )


the 2nd question was "I can't access to you website, where can I get
the source ?"
=====================================================

I get some mail from chinese guy saying that they can't access  to
http://draconux.free.fr/os_dev/linux0.01.html
I suppose even http://free.fr will not work.
Maybe this is because of politics problem between France and China ?

Anyway, you can get the last kernel source code here:
http://www.kernel.org/pub/linux/kernel/people/abdel/linux_0.01/sources/linux-0.01-rm-3.5.tar.gz
hopefully kernel.org work in any country :D

Regards,

-- 
Abdel
http://draconux.free.fr/
