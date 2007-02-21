Return-Path: <linux-kernel-owner+w=401wt.eu-S1423206AbXBUWiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423206AbXBUWiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423216AbXBUWiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:38:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423206AbXBUWiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:38:24 -0500
Message-ID: <45DCC93D.1030506@redhat.com>
Date: Wed, 21 Feb 2007 17:35:41 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DCC8A7.1020908@redhat.com>
In-Reply-To: <45DCC8A7.1020908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Greg KH wrote:
>> This is the start of the stable review cycle for the 2.6.19.5 release.
>>
>> This will probably be the last release of the 2.6.19-stable series, so
>> if there are patches that you feel should be applied to that tree,
>> please let me know.
> 
> This patch should go in 2.6.19 and 2.6.20 -stable as well.
> (It's in 2.6.21-rc.)
> 
> 
> 
> ------------------------------------------------------------------------
> 
> From: Steve French <sfrench@us.ibm.com>
> Date: Mon, 22 Jan 2007 01:19:30 +0000 (+0000)
> Subject: [CIFS] Fix oops when Windows server sent bad domain name null terminator
> X-Git-Tag: v2.6.20^0~147^2
> X-Git-Url: http://www2.kernel.org/git/?p=linux%2Fkernel%2Fgit%2Fsfrench%2Fcifs-2.6.git;a=commitdiff_plain;h=8e6f195af0e1f226e9b2e0256af8df46adb9d595
> 
> [CIFS] Fix oops when Windows server sent bad domain name null terminator

Oops, this is already in 2.6.20.
