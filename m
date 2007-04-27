Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXD0LXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXD0LXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbXD0LXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:23:21 -0400
Received: from web36713.mail.mud.yahoo.com ([209.191.85.47]:44668 "HELO
	web36713.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755635AbXD0LXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:23:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nlyrKgEfBhLP6gaY/k/yKJ3X/jodvYBW/N1ibb1NiCDXbij9H+tl1O4k4qcdGbw9XIsolNHn2AEqaj2hzUspYCrpe44lqc+5vfiKxp2pHPPnCvNJg7Ky/zOlyTi4zsYfN01dZG4NM4DpIqCRN3TdLHltUWQtP8KFNhg/Q25sH8E=;
X-YMail-OSG: pVcM57UVM1lTzhNI9g7TwjqNiLmw4sy9eCZQXx.eag6YxUffPa0MduuKfAQEebgxLER0QDjJv60_qT3UMgaXzBQGIxTeXyB65xv_aZs3luhRQX_5C1rNx6V4FAVvvg--
Date: Fri, 27 Apr 2007 04:23:19 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
In-Reply-To: <4631AB42.3060708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <603217.22031.qm@web36713.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I have submitted my version only after I have failed to find a stable
> version of your driver for the current kernel. If there is one, just
> post link to the patch. If not, let's make one.
> 
As I already said, I'm not aware of any issues with version 0.8 of the driver. If you have any
problems with it, I'll be glad to fix them.

The version in question was recently committed into the -mm tree. Otherwise, it's available from
the project's website for a couple of months now:

http://developer.berlios.de/project/showfiles.php?group_id=5510


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
