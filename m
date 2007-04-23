Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXDWGm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXDWGm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXDWGm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:42:26 -0400
Received: from [70.254.190.220] ([70.254.190.220]:39717 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753077AbXDWGmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:42:25 -0400
Date: Mon, 23 Apr 2007 06:42:24 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Rik van Riel <riel@redhat.com>
cc: Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: <462C5034.9090403@redhat.com>
Message-ID: <Pine.LNX.4.64.0704230640540.25153@server.thyself>
References: <20070423020046.GA28477@omnifarious.org> <462C2E5B.1080008@redhat.com>
 <Pine.LNX.4.64.0704230353000.25153@server.thyself> <462C4858.3050006@redhat.com>
 <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com>
 <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Apr 2007, Rik van Riel wrote:
> William Heimbigner wrote:
>
>>  If there was 1) a maintainer and 2) code that didn't break "coding
>>  standards", would it be included in the kernel?
>
> While I cannot speak for Linus and Andrew, code that fulfills
> these criteria (and is useful to have - reiser4 seems to have
> enough user interest) usually gets accepted.
>
> http://kernelnewbies.org/UpstreamMerge has some hints.

So in conclusion / to answer Eric's question,
1) reiser4 needs a maintainer
2) reiser4 needs the code quality cleaned up
3) Until those two things happen, it's extremely unlikely that it will be 
included in the kernel.

Correct?
William Heimbigner
icxcnika@mar.tar.cc


