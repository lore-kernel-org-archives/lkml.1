Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXFAWRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXFAWRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbXFAWRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:17:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:32865 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbXFAWRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:17:32 -0400
Message-ID: <46609AEC.4070603@zytor.com>
Date: Fri, 01 Jun 2007 15:17:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Scott Preece <sepreece@gmail.com>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>	<28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com>	<alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com>	<m3sl9b5vcm.fsf@maximus.localdomain>	<7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com> <m3fy5b5nrt.fsf@maximus.localdomain>
In-Reply-To: <m3fy5b5nrt.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> "Scott Preece" <sepreece@gmail.com> writes:
> 
>> This is a question worth answering - is it rude to ack/nak a patch if
>> you're not a maintainer or otherwise known-to-be-trusted, or is it OK
>> for anyone to express an opinion? Andrew's patch text seems to imply
>> that it's generally OK.
> 
> Every pair of eyes (or a single one) looking at the patch in question
> is a good thing. I can't imagine why would one want to look at the
> code if he/she can't ack or nak or otherwise comment it.

I think the comment had to do with the concept that ACK/NAK implies
authority.  If you're not the maintainer, it's rude to imply that you
are.  Obvious, test reports (good or bad!) are always welcome.

	-hpa
