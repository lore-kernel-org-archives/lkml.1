Return-Path: <linux-kernel-owner+w=401wt.eu-S1765733AbXE2UOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765733AbXE2UOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXE2UNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:13:53 -0400
Received: from gw.goop.org ([64.81.55.164]:53847 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbXE2UNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:13:52 -0400
Message-ID: <465C8980.9010306@goop.org>
Date: Tue, 29 May 2007 13:13:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       Christoph Lameter <clameter@sgi.com>, tes@sgi.com
Subject: Re: 2.6.22-rc2: known regressions with patches
References: <46559B62.5040903@googlemail.com> <4658D26C.9010803@goop.org> <20070528011502.GW85884050@sgi.com>
In-Reply-To: <20070528011502.GW85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Patience, please. We like to have some QA coverage on a changes that
> affect the writeback path in such a subtle manner before saying it
> is good to go. Just releasing the fix into the main tree would be
> irresponsible as there is the real possibility of the fix causing
> other subtle corruption problems.
>   

Oh, yes, I completely agree.  But cooking in -mm isn't incompatible with
that.

    J
