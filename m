Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXDAP6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXDAP6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXDAP6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:58:13 -0400
Received: from web51601.mail.re2.yahoo.com ([206.190.38.206]:44350 "HELO
	web51601.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933471AbXDAP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:58:12 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 11:58:12 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=N4Ob9OqokC76nUR1tez04Ua7Uuej/+01vt1njvLf8r9m9jfNitXFELB4zYrlW6A6rPWGxODuoC2q7G9YAlhUwrBnL5hwKzR5Up/gOdYqVHXqH4o2lZZhAhytjNZo09lu3sQynJ84FGRQvpMZcMVUf/AbjD6J8wiCpcVgH35IOL0=  ;
Message-ID: <20070401155132.34029.qmail@web51601.mail.re2.yahoo.com>
X-YMail-OSG: wK4DddgVM1l_dol6yTEcAN8eBD.baz8CCBv18MoiNddeoB3g2fKFJ0bJJfNitZjyJ4Oh9_2kMUYvqCDY1doNhE2_3f2J3r.xRa0zl4TeOHfD71TASjKD0gQAv8FKlw--
Date: Sun, 1 Apr 2007 08:51:32 -0700 (PDT)
From: Ashish Singhai <hybrid.rules@yahoo.com>
Subject: PCI: iomem bigger than 4GB
To: linux-kernel@vger.kernel.org
Cc: hybrid.rules@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please refer to Andrew' post on this thread on PCI
subsystem assigning prefetchable memory bigger than
4GB:

http://lkml.org/lkml/2006/11/24/160

This patch is not included in 2.6.20.1 or earlier --
it would be helpful if we could have this patch
considered. I have tried it in a simulated environment
and it works.

Thanks.

Ashish

PS: Pls. CC: me on any replies since I am not
subscribed to LKML.


 
____________________________________________________________________________________
Never miss an email again!
Yahoo! Toolbar alerts you the instant new Mail arrives.
http://tools.search.yahoo.com/toolbar/features/mail/
