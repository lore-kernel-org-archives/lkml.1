Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbXBJTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbXBJTqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXBJTqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:46:19 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:47741 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbXBJTqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:46:18 -0500
Message-ID: <45CE20E5.8000107@gmail.com>
Date: Sat, 10 Feb 2007 20:45:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: avi@qumranet.com, kvm-devel@lists.sourceforge.net
Subject: KVM oops: killing interrupt handler
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

My schoolmate got this while using kvm-12 on 2.6.20-rc6:
http://www.fi.muni.cz/~xslaby/sklad/kvm-intel-panic/a/

Unfortunately it's only shots taken by camera. If we are able to reproduce it in 
2.6.20, we'll grab netconsole output.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

