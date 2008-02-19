Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYBSQM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYBSQM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYBSQMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:12:49 -0500
Received: from smtp01.isdsl.net ([196.26.208.190]:51283 "EHLO smtp01.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYBSQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:12:48 -0500
X-netsentry.modernarch.co.za-MailScanner-Watermark: 1204042340.51694@JJpm7JOAmwTTo4yUrihDog
Message-ID: <47BAFFE9.6050707@networksentry.co.za>
Date: Tue, 19 Feb 2008 18:12:25 +0200
From: Gregory Nietsky <gregory@networksentry.co.za>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <20080219094034.GD6485@one.firstfloor.org> <20080219095622.GC4164@uranus.ravnborg.org> <20080219095834.GB6940@one.firstfloor.org> <20080219115537.GB5604@uranus.ravnborg.org>
In-Reply-To: <20080219115537.GB5604@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-netsentry.modernarch.co.za-MailScanner-Information: Please contact Network Sentry  for more information (www.networksentry.co.za)
X-netsentry.modernarch.co.za-MailScanner: Found to be clean
X-netsentry.modernarch.co.za-MailScanner-From: gregory@networksentry.co.za
X-Scan-Signature: 1e5579062dd15e064ef5c9c6f539d932{40}}
X-Trace: smtp01.isdsl.net 1JRV4z-0006Go-Cw cb15d2461ca67bd8f29af2fbb766b3cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> I'm not sure either it's a good idea to try to merge mISDN if the
>> maintainers don't think it is ready yet.
> 
> In the spirit of relase early - relase often we should at
> least see what is going on.
> 
well to add mISDN to the kernel tree is straight forward

./std2kern

and the out of tree set becomes in tree a bit of git magic and you have 
a patch.

im advocating it for now alongside isdn4linux prehaps marked as 
"EXPERIMENTAL" im not involved in the mISDN team im a contributor/hacker.

need the buy in from Cristian R/Karsten K.

FYI here in south africa ISDN BRI is widely available with the high 
costs of ISDN PRI this is the best/most practical solution for VOIP.with 
ADSL only now becoming availble on mass the "fastest" connection is 
still 64/128k ISDN in many areas.the hardware is easily available from 
all outlets.my device of choice is a cheap USB modem that comes in @ 30$ 
US per port (can use upto 8) the 4 port digium card comes in @ 650$.


Greg

--

This message has been scanned for viruses and

dangerous content by Superset Technology, and 

is believed to be clean.

http://www.superset.co.za


