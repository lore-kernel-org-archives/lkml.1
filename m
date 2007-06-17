Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXFQIEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXFQIEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXFQIEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:04:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:14963 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbXFQIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IH7S2qZ2UiiVe4QO/MTo6zfgnZ+fubsGCleYTmR9FKQtWzDHeutZHdsdv09Qly0kKwGZ3Fx9nG9rg8aR6O3KCfiw8szBXYlEGltA+sBgXgzBPs4atekXpqU8B4V3tlXzlDs5FGB/2NVF1FM2RIJP6pzNyLYnfRUPdq119y1ICCU=
Message-ID: <4674EACB.90509@gmail.com>
Date: Sun, 17 Jun 2007 17:03:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>, David Greaves <david@dgreaves.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] block: always requeue !fs requests at the front
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de> <20070615094246.GN29122@htj.dyndns.org> <20070615110544.GR6149@kernel.dk> <20070616195401.GA6929@infradead.org> <20070617072957.GJ6149@kernel.dk>
In-Reply-To: <20070617072957.GJ6149@kernel.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> I'd much much prefer having a description of the problem in the actual
>> comment then a hyperlink.  There's just too much chance of the latter
>> breaking over time, and it's impossible to update it when things change
>> that should be reflected in the comment.
> 
> The actual commit text is very good though, but I agree - I don't think
> the url comment is worth anything. I did consider just killing it.
> However, the comment does describe the problem, so I think it's still
> ok.

I thought the whole story was too long for the comment.  Feel free to
kill or edit it.

-- 
tejun
