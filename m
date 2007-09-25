Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbXIYILi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbXIYILi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760423AbXIYILI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:11:08 -0400
Received: from web52009.mail.re2.yahoo.com ([206.190.48.58]:36986 "HELO
	web52009.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760385AbXIYILH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:11:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Wqyr0FEtTCJEU8emPjHYzzZhWHUSSk42GGsbAmrhftTlr0z1jUwoZKkeUYgNP2Rvu/BEwPy5VOfCpuHK+siCvoVaKa5frwMgVbRsFO4QvoAR9iVm2IdWv4UHG8hqfha3HB/76EwbgAVNupY5Zt4RBLUgL+RaGUTQR+QbVK9THoY=;
X-YMail-OSG: BjIqQisVM1m.uL_Wu8bxVzo1RPdb9I0e.R0j0ZMGQq89y46rnoXi7hqLmS0.qCjLqA--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Tue, 25 Sep 2007 01:11:05 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] include/linux/mutex.h: unclear reference to convention
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <713129.73007.qm@web52009.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to maintain the convention of documenting the interface only in .c files, 
you should write the convention in so many places in .h files that no one could overlook it.
But I think the convention is bad and it would be better to document the interface also in
.h files where it is defined. The convention is bad because it requires people to jump to
other files to understand .h files.



      __________________________________  
Alles was der Gesundheit und Entspannung dient. BE A BETTER MEDIZINMANN! www.yahoo.de/clever
