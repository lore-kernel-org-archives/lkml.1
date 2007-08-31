Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXHaW1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXHaW1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXHaW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:27:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbXHaW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:27:12 -0400
Message-ID: <46D895AE.8060308@redhat.com>
Date: Fri, 31 Aug 2007 18:26:54 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: [ANNOUNCE] DeskOpt - on fly task, i/o scheduler optimization
References: <46D8354A.3030208@googlemail.com>
In-Reply-To: <46D8354A.3030208@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi,
> 
> Here is something that might be useful for gamers and audio/video editors
> http://www.stardust.webpages.pl/files/tools/deskopt/
> 
> You can easily tune CFS/CFQ scheduler params

I would think that gamers and AV editors would want to be using deadline 
(or maybe even as), not cfq.  How well does it work with other I/O 
schedulers?

	-- Chris
