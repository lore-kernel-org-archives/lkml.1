Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbXFECdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbXFECdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbXFECdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:33:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbXFECdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:33:13 -0400
Message-ID: <4664CAFF.2040300@zytor.com>
Date: Mon, 04 Jun 2007 19:31:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr> <46644F57.80005@zytor.com> <20070604175751.GB3437@dhcp83-182.boston.redhat.com> <20070605021027.GD2498@localhost.localdomain> <20070605021210.GG31462@havoc.gtf.org>
In-Reply-To: <20070605021210.GG31462@havoc.gtf.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> So, it seems that we can reach an agreement. Any other comments or suggestions?
>> Or can someone ack/merge this patch?
> 
> Honestly, I think not reaching an agreement is a good thing.
> 
> "style" is always ultimately in the eye of the beholder, and reasoned
> people come up with multiple answers to the same question.
> 
> Sometimes it's better _not_ to set things in stone.  "use your
> judgement" and "follow the existing style" go a long way.
> 

Indeed.  Quite frankly, style guides would be a lot less obnoxious if
there weren't always people who felt the need to "correct" other
people's styles.  That is usually a rather obnoxious thing to do, at
least as long as the code is reasonably clean to start out with.

	-hpa
