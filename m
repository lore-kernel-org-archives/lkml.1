Return-Path: <linux-kernel-owner+w=401wt.eu-S1030632AbXBZUI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030632AbXBZUI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030637AbXBZUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:08:59 -0500
Received: from web52908.mail.yahoo.com ([206.190.49.18]:48189 "HELO
	web52908.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030632AbXBZUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:08:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3wlry99PsdLA83u+YAK7zeKpSznZ/wjebwHTGXo7Igy0fe+3/D0KMca5MnEVavgwDOc2aon6Lns8uBnHbvhrPhR75ao+DuJBwkuOwQ9VqxQv/OfvIeFlt7stfcw1WQbw2romRNrSOQF4NpNVjmmGDG4yc9VhDyoaa9fLZCdFM+8=;
X-YMail-OSG: cghLJOIVM1kevzqidod0mmZIq.UQKLBHfGGbi1Pkm4CxKvtYdFEySl9qEqMbttzJuD38VIadpWbCYgd7GLQA5eQx0EKZm4TX.l_rBlACw62M6hFWARvZfx7mH1dOLhGmBEtschS6MUDgeGQ-
Date: Mon, 26 Feb 2007 20:08:56 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
In-Reply-To: <20070226104238.16829275.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <91910.66950.qm@web52908.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Do you have any of the preceding kernel log messages?
> or can you get them?

Unfortunately, there was none. I posted everything there was. Race condition, perhaps?

Cheers,
Chris


	
	
		
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
