Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXIKTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXIKTzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbXIKTz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:55:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44390 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964AbXIKTz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:55:27 -0400
Message-ID: <46E6F2A8.2020104@pobox.com>
Date: Tue, 11 Sep 2007 15:55:20 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <46E6EE96.9060309@nortel.com>
In-Reply-To: <46E6EE96.9060309@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Randy Dunlap wrote:
> 
>> +Thunderbird (GUI)
>> +
>> +By default, thunderbird likes to mangle text, but there are ways to
>> +coerce it into being nice.
> 
> Can someone describe the problems with just attaching the patch in 
> Thunderbird?  It's what Martin says he does on the linked document...

Email clients don't like to quote attachments, even text/plain ones, 
which then makes attached patches much more difficult to review and 
comment on (i.e. you greatly reduce the number of reviewers).

	Jeff



