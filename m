Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYKQWaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYKQWaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYKQW34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:29:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:59462 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYKQW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=lI5rAzjQUXZ6Q66UpMas5uNoXEXxAGe7mmaMd98NfOS3o1iLOmYNRZH++LDAAC805x
         Y20t4QtZJLG7j/nQvmtRIppc/jjN3HzYW/1nxdckaN28J8GEFCYQVGjTR98lnoZyKIqX
         egYglzGhyiJlvwam/fmPywbopn6n/05P8ryjE=
Subject: stuck connections or not
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 14:29:51 -0800
Message-Id: <1226960991.3148.2.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
I'm noticing the loopback device
is always established i.g. 
watch netstat -ntu

Every 2.0s: netstat -ntu
Mon Nov 17 14:28:11 2008

Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address
State
tcp        0      0 127.0.0.1:8765          127.0.0.1:57429
ESTABLISHED

tcp        0      0 127.0.0.1:57429         127.0.0.1:8765
ESTABLISHED

Not sure if this is normal or not.

regards;


-- 
Justin P. Mattock <justinmattock@gmail.com>

