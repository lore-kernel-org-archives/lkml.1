Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZBNWf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZBNWf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZBNWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:35:20 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:36094 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZBNWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:35:19 -0500
Date: Sat, 14 Feb 2009 22:35:18 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Mark Lord <liml@rtr.ca>, =?ISO-8859-15?Q?Hanno_B=F6ck?= <hanno@hboeck.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
In-Reply-To: <4996E924.3060600@ru.mvista.com>
Message-ID: <alpine.LFD.1.10.0902142228410.651@ftp.linux-mips.org>
References: <200902131428.40212.hanno@hboeck.de> <499584FC.2050104@gmail.com> <200902141352.24277.hanno@hboeck.de> <4996C563.9090900@ru.mvista.com> <4996D443.4060103@rtr.ca> <alpine.LFD.1.10.0902141526310.651@ftp.linux-mips.org>
 <4996E924.3060600@ru.mvista.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

> > not explicit about how words 57 and 58 were meant to be ordered and some
> > manufacturers interpreted it one and some the other way.
> 
>   However, the drive vendors should've really thought better before reporting
> capacity in *middle-endian* format. :-)

 Oh, come on!  Don't accuse everyone of thinking.  Besides, someone had to 
try that reverse-pdp-endian mode, didn't they? ;)

  Maciej
