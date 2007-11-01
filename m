Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXKAJK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXKAJK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXKAJKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:10:52 -0400
Received: from web61314.mail.yahoo.com ([209.73.179.83]:39582 "HELO
	web61314.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755124AbXKAJKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:10:51 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 05:10:51 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ubndGp2HvCyujVsSB+azYPWSd9u70QlKdvh/lMHC3i2C5tNqaU3SNAh9nHCo1g7Yb78ic45gEHvefNyGmi7oOpSrsDwwIu3g8jRDBR72U5J8CI6bz9MVCV2WDC3wr0JiaHrgWSDPW3+A5aow8MQbND4MWqh5Y7o23MyaAxUaPb0=;
X-YMail-OSG: C2ZhrioVM1n5cuo6JLoVsxMY3R8bPKFg583c55pcAlnQC15Z8FogfuMu7WRQrWwoaoBHu6ZvUQM6MHAbdtPYDU4VIBPK51ORhV0teTb9TjGWgFcrJCWHvgU8q4DSU4o-
Date: Thu, 1 Nov 2007 02:04:10 -0700 (PDT)
From: ramkumar koppu <ramkumarkoppu@yahoo.com>
Subject: Corrputed Core files
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <177770.25577.qm@web61314.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a probelm wirh core files. we have a system
where 14 nodes are working together for telecom
application. all these are NFS mounted to disk.
(sharing the disk). in one of node application is got
SIGSEGV and generated core file. but its not properly
copied to the disk. its supposed to copy around 150MB
core file but it was around 50-80MB. thats why GDB is
not able to read this core file. can u guys please
suggest me how to splve this problem?
I am waiting for ur response.

Thanks & regards
Ramkumar


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
