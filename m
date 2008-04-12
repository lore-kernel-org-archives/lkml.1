Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYDLBAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYDLBAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 21:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbYDLBAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 21:00:01 -0400
Received: from n59.bullet.mail.sp1.yahoo.com ([98.136.44.43]:43804 "HELO
	n59.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755975AbYDLBAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 21:00:00 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 770699.7911.bm@omp504.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=GHr2YXyjhPA4/D5VjWwdm7N6+pIZhUMpvHqa0RAZ8JizXK0hL8iiiRm00DwFvwjMR9AqD7fiw7j6qsDJhi22eAOPB3+eeI2PiGLKjNAjAyCcitJMQJBOYEd2OjOY0oW5H303O87DvMg5SCkuWnLWdCxfvK/x9aSRmTNnsrfwRMA=;
X-YMail-OSG: _GAH5QgVM1miiig4aHtSQXQXU.0fWl_06RtK9DHplvxOQ.nvLgB2tfUgPToI5kOCrA--
Date: Fri, 11 Apr 2008 21:59:59 -0300 (ART)
From: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24
To: Luis Sousa <ls.luis_sousa@yahoo.com.br>, Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <611220.91904.qm@web46005.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:

> --- Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:
> > 
> > --- Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:
> > 
> > > --- Jeff Garzik <jeff@garzik.org> escreveu:
> > > 
> > > > Luis Sousa wrote:
> > > > > I've been having consistent hard system freezes for a
> > > > > long time, every 2 days or so, and finally decided to
> > > > > move to the most recent stable kernel. Unfortunatelly
> > > > > that didn't fix it. The freezes seem to be io-related;
> > > > > they started since I moved my drive to sata. They seem
> > > > > to happen mostly when there's an io-intensive operation,
> > > > > like extracting a big archive; a reboot is needed.
> > > > 
> > > > We need more info, namely full 'dmesg', 'lspci -v', and your kernel config.
> > > > 
> > > > Also, make /sure/ you are not running closed-source modules known to 
> > > > crash the system, like ndiswrapper or nvidia graphics driver.
> > > > 
> > > > 	Jeff
> > > 
> > > I'm quite sure.
> 
> It seems I have a failing RAM problem.


> I'll try fixing that and if it still keeps crashing, I'll be in touch.
> 
> --
> Luis Sousa

OK, it's definitely not the RAM; I tried three new RAM modules, and the
crashes continue with all of them. Sometimes the sysrq keys work, usually
only for rebooting. Not sure it's sata, but I'm clueless here. Still
seems like a vm thing to me.

--
Luis Sousa


      Abra sua conta no Yahoo! Mail, o único sem limite de espaço para armazenamento!
http://br.mail.yahoo.com/

