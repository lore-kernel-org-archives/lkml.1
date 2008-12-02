Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYLBLeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYLBLeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYLBLeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:34:05 -0500
Received: from web15702.mail.cnb.yahoo.com ([202.165.102.69]:33650 "HELO
	web15702.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751844AbYLBLeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:34:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=XLxdaMMkdmNlwy8UcUSF9pOcJoxymq5H2VVXlrZjOSVNofsTYfdXCzO/tONFnsb8u1E6ECn/c42W2B200+Gs7+fnRzqJEC4QmGdJvNolFjIYX2KcXflSowhNbvIKU/FBq0WPJx2cBDzurViXuPFyYg+O1l8LVJJWhLkkNuNkg+4=;
X-YMail-OSG: rKb73tgVM1knp6fxdaZzEutAEOK2gv5_IiEm5qYtMbn49lJEey5dfYrVAVsJPCIHD4n.lfE1W.Nh1MwW46oj5wIBJNcgWpziEGI8QaFpU7KdOefRonnZRPs6fy5kvPDBehStpbCmZZ0eJiLqSwZmht078w--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 2 Dec 2008 19:33:59 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: question related page frame reclaim on embedded system
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <902363.74520.qm@web15702.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

1, I have a question related page frame reclaim .
As i understood , under low memory pressure page frame reclaiming will
swap  Least Recently Used cache to disk .
So my question is assume no swap space ,how to works ?
Whether the  Least Recently Used  slab cache , inode cache  etc  will
be discard since no swap space .

2. BTW ,I have already used my gmail account subscribe the linux kernel mail list .but can not post the question to mail list , i used plain text format . 
why ? I have seen many people use account of gmail  to post question .



Thanks advanced .
Best Regards .
Peter Meng


      
