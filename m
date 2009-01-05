Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZAEOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZAEOlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZAEOk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:40:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55598 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbZAEOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:40:56 -0500
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 09:40:56 EST
X-Sasl-enc: p0ii0BFEGz/E6Rn57sv60RAT2mRzZiv49Ak2u5vYfUMt 1231165507
Message-ID: <49621841.7040108@ftml.net>
Date: Mon, 05 Jan 2009 08:25:05 -0600
From: Roman Kononov <kononov@ftml.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, Peter Klotz <peter.klotz@aon.at>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org> <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de>
In-Reply-To: <20090105064838.GA5209@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-05 00:48 Nick Piggin said the following:
> I believe this patch should solve it. Please test and confirm before
> I send it upstream.

3 systems with 2.6.27.10 have worked overnight with dd running 
continuously. They all failed within 20 minutes without the patch.

Thank you,

Roman
