Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZAHBI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZAHBI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZAHBIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:08:50 -0500
Received: from web52503.mail.re2.yahoo.com ([206.190.48.186]:30306 "HELO
	web52503.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754727AbZAHBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:08:50 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 20:08:49 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=FE0g9CsN2NEFfAwnMUt813DLn6CE3PlQqmAL6MRDImREPsf+MIDYENpOn3hGIoMXp467DWo2Xmn8o/gCX4Kx63HRGpKbU7aJq4bmNJa4R4PPxXWieShiV1GqefThygq67FHOrKHYRGmpEWmK6yJkZv1ZoCLoh3JoJM4sQehne00=;
X-YMail-OSG: 7Kf.wTMVM1kLb.0yzjrO5AyHHKS83UUszLOqw9wabpIftW8.6juulmSniw87gdz771a6VCIAos5qpuRu2o1gnUjefaC.1q9l50kKpTqP6W9M38SrY0u2sklqbhaR31jzGJ_p0wE.gszUHU8oQ_VGsY8Z_QF3qk1Ly9qNGHwsm0W0E6o25OTh3Sl5tXbKJ0Flkt3UnbPjqKtX3rjnxyqwI3MiVA--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Wed, 7 Jan 2009 17:02:08 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: SSD Raid 0 Chuck Size [OT]
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <689063.5525.qm@web52503.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a quick question. I'm trying to set up a Raid 0 array using solid state drives (SATA II). My thinking is that because these drives are unbuffered that a 4K chuck size would be fastest.

Am I correct?

I thought I'd ask here because people here would actually know the right answer.

Thanks in advance.


 Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com



      
