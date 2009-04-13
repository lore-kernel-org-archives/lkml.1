Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZDMJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZDMJf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZDMJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:35:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56670 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbZDMJfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:35:11 -0400
Message-ID: <49E30746.3010509@garzik.org>
Date: Mon, 13 Apr 2009 05:35:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jack Stone <jwjstone@fastmail.fm>
CC: Christoph Hellwig <hch@infradead.org>, Felix Blyakher <felixb@sgi.com>,
       kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [PATCH 56/56] xfs: Remove void casts
References: <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-57-git-send-email-jwjstone@fastmail.fm> <81C20178-5096-4E2E-A588-28AAE674748F@sgi.com> <20090413093232.GA14320@infradead.org>
In-Reply-To: <20090413093232.GA14320@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 09, 2009 at 12:37:08PM -0500, Felix Blyakher wrote:
>> On Apr 8, 2009, at 6:22 AM, Jack Stone wrote:
>>
>>> Remove uneeded void casts
>>>
>>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
>> See comments below.
> 
> Agree with the comments, als the subject line seems wrong, the patch
> doesn't remove void casts, but casts from a void pointer to a typed
> one which aren't nessecary.
> 
> Also please don't submit patches like this in a large series to the
> world but separately to the listed maintainer / mailinglist of each
> subsystem as there is no interdependency nor a general interest.

And what evil have I committed, to be cursed with being CC'd on every 
damn one of these things?

	Jeff




