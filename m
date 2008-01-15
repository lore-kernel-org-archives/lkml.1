Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYAOQIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYAOQIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYAOQIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:08:46 -0500
Received: from stinky.trash.net ([213.144.137.162]:43570 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYAOQIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:08:45 -0500
Message-ID: <478CDA7F.30207@trash.net>
Date: Tue, 15 Jan 2008 17:08:31 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24-rc7-git4: Reported regressions from 2.6.23
References: <200801122205.34871.rjw@sisk.pl>
In-Reply-To: <200801122205.34871.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> [RFC: Would that be useful if I sent regression-fixing patches, CCed to the
> appropriate maintainers/lists, along with the reports?]
> 
> This message contains a list of some regressions from 2.6.23 reported since
> 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 

> Subject		: iptables won't work
> Submitter	: Kristoffer Malmström <malmis@malmis.com>
> Date		: 2007-12-28
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9657
> Handled-By	: Patrick McHardy <kaber@trash.net>


The reporter has disappeared, so I guess this wasn't a regression
caused by the kernel but some other mistake.
