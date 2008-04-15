Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbYDOCl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbYDOCl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760539AbYDOClT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:41:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827AbYDOClS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:41:18 -0400
Message-ID: <480415AB.2070308@zytor.com>
Date: Mon, 14 Apr 2008 19:40:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <47FFD3F3.50107@redhat.com>	<821384.64293.qm@web52504.mail.re2.yahoo.com>	<20080411213843.GH2160@csclub.uwaterloo.ca>	<4802608A.3040901@zytor.com>	<20080414151222.GF7385@csclub.uwaterloo.ca>	<m3prsrj51j.fsf@maximus.localdomain> <480403DE.4070901@zytor.com> <m3lk3fj3gd.fsf@maximus.localdomain>
In-Reply-To: <m3lk3fj3gd.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> It shouldn't really matter, since "below" produces a similar spectrum
>> at a slightly lower frequency.
> 
> Sure for CPU/TSC and similar clocks but in case of well-known (not
> calibrated) frequency it could be a problem. Not sure if there are
> such cases.

There is - the 14.31818 MHz clock, but as previously noted it is 
generally not spread.  If *that* clock is spread I would expect problems.

	-hpa
