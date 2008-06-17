Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbYFQWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbYFQWAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbYFQWA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:00:26 -0400
Received: from web52506.mail.re2.yahoo.com ([206.190.48.189]:47618 "HELO
	web52506.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754995AbYFQWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:00:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=xVMQIdyFyBuEMtVYTjU/3tmFglI114gvBwHS13Es/eicynHFA0TgbyQE15WhWtAH6hY6bBUChC/rAsR43DRitKTO4+vrdaoEY8lAXqeMK1BaF+niEhyyea1j9cq6djVlu6YCGw1hH1V8WO9KbkP1jAgjrLQ2BNnvg18jQLNLmlo=;
X-Mailer: YahooMailWebService/0.7.199
Date: Tue, 17 Jun 2008 15:00:25 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Reply-To: mperkel@yahoo.com
Subject: AMD Dual Core vs. Quad - Power Management
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <364301.54904.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Been running a few tests and an AMD motherboard booting 2.6.25 from flash uses 0.33 amps if the CPU is a AM2 Athlon 6000. But if I used a Phenom Quad core CPU 9550 it pulls 0.55 amps.

In theory the 9550 should pull less because it's a lower TPD and the phenom processor is supposed to be smarter about power management.

So - why is the Phenom pulling more power? Is it because power management software for the Phenom isn't updated yet?

Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      
