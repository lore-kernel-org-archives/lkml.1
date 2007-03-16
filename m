Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXCPLbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXCPLbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXCPLbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:31:00 -0400
Received: from web52905.mail.re2.yahoo.com ([206.190.49.15]:23585 "HELO
	web52905.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932113AbXCPLa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:30:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=G0eywr0LChxfzS87of1j3liM6M0ULGT2Ni0ZkkNtYzsjXCzqm1Cwwq7y+DqtwZCgG5foKs8/NRW0i2hQjcQOwRVy3vyrRZ3TlOSVhxrPTJ5NXGn+waovM0jMpNVc1+JVhX6nzo/gaIs7Cq2/fQd+op54f92Y0HPgwDduyMiUS60=  ;
Message-ID: <20070316113058.13445.qmail@web52905.mail.re2.yahoo.com>
X-YMail-OSG: j_peDx0VM1lIdWrxMkV.yHPhkLuKDjCTYJ40TKKEuR_tx0ktIk0khVodDOuXatnxnQ--
Date: Fri, 16 Mar 2007 11:30:58 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020703160325h6e12069fl788cdb44114f817f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Please try out the following patch to see if we catch a reference
> counting underflow:
>
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/detect-atomic-counter-underflows.patch

Sure, I can do that.

Cheers,
Chris



	
	
		
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
