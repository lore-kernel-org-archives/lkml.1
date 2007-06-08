Return-Path: <linux-kernel-owner+w=401wt.eu-S1030692AbXFHRrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692AbXFHRrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030581AbXFHRq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:46:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937221AbXFHRq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:46:26 -0400
Message-ID: <466995CD.8030506@redhat.com>
Date: Fri, 08 Jun 2007 13:45:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Dave Jones <davej@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/54] 2.6.21-stable review
References: <20070608072127.352723000@sous-sol.org> <20070608172852.GP27332@redhat.com> <20070608173403.GB10561@kroah.com>
In-Reply-To: <20070608173403.GB10561@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2007 01:34 PM, Greg KH wrote:
> On Fri, Jun 08, 2007 at 01:28:52PM -0400, Dave Jones wrote:
>> Or maybe cc: the reviewer list when patches get added?
> 
> Oh, we can easily do that as we have a script that notifys the submitter
> that the patch has been added.  If you all don't mind getting the noise,
> I'd be glad to make that change.
> 

To keep up to date all you need to do is pull the GIT tree regularly.
Maybe a mailing list for stable-commits could be added, like mm-commits?

