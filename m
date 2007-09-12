Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXILTSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXILTSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXILTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:18:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbXILTSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:18:24 -0400
Message-ID: <46E83B16.2070608@redhat.com>
Date: Wed, 12 Sep 2007 15:16:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Chris Friesen <cfriesen@nortel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <46E6EE96.9060309@nortel.com> <46E6F2A8.2020104@pobox.com>
In-Reply-To: <46E6F2A8.2020104@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Chris Friesen wrote:
>> Randy Dunlap wrote:
>>
>>> +Thunderbird (GUI)
>>> +
>>> +By default, thunderbird likes to mangle text, but there are ways to
>>> +coerce it into being nice.
>>
>> Can someone describe the problems with just attaching the patch in 
>> Thunderbird?  It's what Martin says he does on the linked document...
> 
> Email clients don't like to quote attachments, even text/plain ones, 
> which then makes attached patches much more difficult to review and 
> comment on (i.e. you greatly reduce the number of reviewers).

Interestingly, Thunderbird does this right and simply
adds text/plain attachments to the quoted text.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
