Return-Path: <linux-kernel-owner+w=401wt.eu-S1763955AbXGFVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763955AbXGFVhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761152AbXGFVh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:37:28 -0400
Received: from web90414.mail.mud.yahoo.com ([216.252.100.166]:46632 "HELO
	web90414.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760834AbXGFVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:37:28 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2007 17:37:28 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=FLn7m1+QGxWvarfAVlcLQgt7jCTG3v+31ZTvBGjNYliYsyKVdNCntD1CC27fcNtk8yk+3q7jIsECha3VOCA+VmAkDpFqfy5qv2rKNLw7Vb+srCRN7s7Tk7JFUMMHBUBF4N4HBh0jf6SZNXU42o08gMIpOSnw6f0OXaNaMe09Tt8=;
X-YMail-OSG: K_bAziYVM1meq3hfkEOUWtsttPldko6eh9Q3HH5xv974WuzObIpEptr.ubb9wsqDikvQJDG4kWoBa_.L_uHCBhNdX7VZQcixEwu9f8r7EpY8VBDqLhDDccwTv07MAw--
X-Mailer: YahooMailRC/651.38 YahooMailWebService/0.7.41.16
Date: Fri, 6 Jul 2007 14:30:46 -0700 (PDT)
From: Khubaib <khabi_uet@yahoo.com>
Subject: runqueue length
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <255428.88208.qm@web90414.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a run time threading library in which I want to
interact with the kernel to find out global system utilization
(especially in SMPs).

My question is: Is there a way to find out from an application that how
many active threads are there in OS? By active, I mean ready to run AND
already running (both separately reported or may be one number).
Similarly a number for how many threads are there in wait queues
(blocked on I/O or waiting for an event or a signal). A program might
have multiple threads. This information is useful for runtime library developers, because they can tune their threads and other scheduling.  accordingly.

Thanks for your time,

-Khubaib 




       
____________________________________________________________________________________
Choose the right car based on your needs.  Check out Yahoo! Autos new Car Finder tool.
http://autos.yahoo.com/carfinder/
