Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbXI1JMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbXI1JMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbXI1JM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:12:29 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:43645 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361AbXI1JM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:12:26 -0400
X-Greylist: delayed 697 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 05:12:25 EDT
Message-ID: <46FCC577.30108@lncsa.com>
Date: Fri, 28 Sep 2007 11:12:23 +0200
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Hannes Dorbath <light@theendofthetunnel.de>
CC: linux-kernel@vger.kernel.org, drbd-user@linbit.com
Subject: Re: [DRBD-user] Crash on 2.6.22
References: <46FCC2BE.7020509@lncsa.com> <46FCC3E4.7030908@theendofthetunnel.de>
In-Reply-To: <46FCC3E4.7030908@theendofthetunnel.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Dorbath wrote:
> On 28.09.2007 11:00, Laurent CARON wrote:
>> The $HOME directories are stored on a drbd (version: 0.7.24
>> (api:79/proto:74)) partition (with an XFS filesystem).
> 
> Was the deadlock with 2.6.22 only in 0.8.x? Is 0.7.x fine with 2.6.22?

I only experienced it with 2.6.22.

Since I pulled the latest svn tree of drbd 0.7.X, it should be pretty
deadlock safe.

Isn't it ?

Laurent
