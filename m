Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbXAXNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbXAXNaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXAXNaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:30:39 -0500
Received: from web52914.mail.yahoo.com ([206.190.49.24]:27893 "HELO
	web52914.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751429AbXAXNai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:30:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=vYX5iyyraVmusM5URzcjwNJ5FYMXCgsyEZNhB315LeL2QjOCCb9+d3d6KaY3k6qpFRGq+RLXq1mZ1M44F7EAgp7EFcnzsaRd8ygTuYCxmeSiKkbWwJF8mKxH1V9YsQrEvt66ubPrcqYgoZ7zNY+8NNi/kFOD+hYFiDGV2HlHSr4=  ;
Message-ID: <20070124133037.98357.qmail@web52914.mail.yahoo.com>
X-YMail-OSG: kjk8MYsVM1lGa3lp0ZcK3.BVPFI4U7ewYqPSbOD4
Date: Wed, 24 Jan 2007 13:30:37 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.18-stable release plans?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But 2.6.18.x must be over now, because the -stable team didn't release a 2.6.18.7 to match
> 2.6.19.2, and all of 2.6.x except for 2.6.19.2 has that weird file corruption bug .

Personally, I dumped 2.6.19.x like a hot coal as soon as I tripped over this bug:

http://bugzilla.kernel.org/show_bug.cgi?id=7707

I didn't take much to trigger it, either. But the silence has been deafening.

Cheers,
Chris



	
	
		
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
