Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbXIXHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbXIXHiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXIXHir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:38:47 -0400
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:37174 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751310AbXIXHiq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:38:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=kg2JxPbX1ZNkWh1AF9ZqpWgvmadp6IGVNdAexjbC8+dOTO6uyV1sCzdUXpmMgYF9dOpUna9hgcEAuGrQpS3XDDZOJgRZfKMhaUjbtavPUwnj8JcTIsQ5OWoS15I8vRqqYTbbdi7+qhPdQOhfLMR6mNR/vh4xxprlIYXi5QcvOwk=;
X-YMail-OSG: 0yN726wVM1kbM8yxuOhBnwLyuNePKgMk_u81MH2tJZRdksn9vzC8weykOdOErj37qhGPq.9zQk9fWGsYHMRpS7lHi32gvMjRG9tudAhSkD67lHmyF6yyxz_sC5UL9_tO0Z4VmHYvh_gr7KdrdchDfnGPfw--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Mon, 24 Sep 2007 00:38:45 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] include/linux/mutex.h: unclear reference to convention
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <377076.1597.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com>:
> Another convention is that we put kernel-doc with the implementation
> (i.e., in .c files) when possible, not with the function prototype.
> Of course, for inline functions or macros in header files, that's
> where the kernel-doc has to live.
>
> so we don't need this patch.

 You should not expect that every reader of the kernel files is aware of 
that convention. I was not and therefore I sought referenced files for 
some time.





      Machen Sie Yahoo! zu Ihrer Startseite. Los geht's: 
http://de.yahoo.com/set
