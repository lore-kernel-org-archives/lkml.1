Return-Path: <linux-kernel-owner+w=401wt.eu-S937372AbXGSJIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937372AbXGSJIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXGSJIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:08:42 -0400
Received: from web57713.mail.re3.yahoo.com ([68.142.236.76]:26868 "HELO
	web57713.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755717AbXGSJIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:08:41 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 05:08:40 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=rCAW3QNnjnz1I3YrxwRus2QfY1V6u3X8/XK5R6adf/TtAn3w/sQCmqt3sxPCu+Zl+YXW6JgN5u1ujtFpGG+/YgmzcqzcRhuqz5F1m6Kj/e6G6CHaRuj7iySOROMLN9j4IgchF3ODeqkSokQAXSiYJpgW+eP8BV18Pqf6ZYIjQSQ=;
X-YMail-OSG: MG1WwhoVM1lz0lPAlZG1DyV0QxnVPsWP0zCT8O9MBS5kq3uUXEDLxdAp3.OmlzdgW5Pvx81Hb72UiEKxybR3owp9vwphTPio9M5EDL2EDeaAiE9RRI2gN8euJdt9QNxUR8akLStcmQyEHw--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.41.16
Date: Thu, 19 Jul 2007 02:01:58 -0700 (PDT)
From: Jacob A <jacoba51-tmp@yahoo.com>
Subject: 2.4 Q: list of open files per inode?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <581196.34917.qm@web57713.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 How can a device driver go over the  list of all the files that are open on a specific inode  instance?

I'd like to avoid doing my own housekeeping.



 The question is about 2.4  kernel.

  

 Thanks,

  

 Jacob







