Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbXHLBmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbXHLBmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 21:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbXHLBmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 21:42:10 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48716 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbXHLBmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 21:42:08 -0400
Message-ID: <46BE621E.9090509@gmail.com>
Date: Sun, 12 Aug 2007 03:27:58 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
In-Reply-To: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2007 03:08 AM, Jesper Juhl wrote:

> This may be a little off topic, but I think it's interresting enough
> to warrent a single mail.
> 
> I just saw a news article (http://www.theinquirer.net/?article=41610)
> about a 3 Socket Opteron motherboard and couldn't help but wonder if
> we are prepared to deal with such a beast, so I thought I'd inform
> everyone :-)
> 
> I'm guessing equipping such a board with 3 single core CPU's could
> show up some interresting corner cases in schedular code and
> elsewhere, I'll bet we have some assumptions somewhere about
> nr_of_cpus being an even number...

I would hope the N=1 case will have flushed out enough of those... :-|

Rene.
