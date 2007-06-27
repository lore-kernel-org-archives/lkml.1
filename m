Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbXF0DfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbXF0DfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXF0De6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:34:58 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:41335 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753107AbXF0De5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:34:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Ml0a9V7J/WpEPQl5F+3/mabx7amb+B/9FKRBY9d80RbcHsHiq/zhXi8QuJPF8KBIKLKN7hejCdzjN4fwWp4Gnvv6XtEBjbkUHtS/o6/BoEd/3yVJYwmkpwI7U4sEhbGc5H2RLXT8SIy3HBGRlPxd/uW4r5aE+KLmoffMuHdoB7o=;
X-YMail-OSG: OLoTMJ0VM1k55nepOX8Y18WYVFwI0Zsin4nQ1HMWFbSTYHKXNUvJulZJ4heKg7fX.PPMHAqOBRIird9SSgzuQ41fFPCKL2vHNB73fHOD9P3eVsvAastkJnwILRP3_w--
Date: Tue, 26 Jun 2007 20:34:56 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: NVidia Driver Support - 1680x1050 mode
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <815294.60672.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to get my Asus M2NPV-VM motherboard and my
Samsung SyncMaster 215tw Digital to work in 1680x1050
mode but 1280x1024 is the most I can get. Chip Set is
GeForce 6150.

Looking in Xorg.0.log it ssems to think that the panel
size is 1280x1024 in spite of my setting telling it
differently.

Sorry if this is off topic but I thought that the
smart people would be here. In Windows I just plug it
in and it works. So I figure Linux should work too. :)



       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
