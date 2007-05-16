Return-Path: <linux-kernel-owner+w=401wt.eu-S934371AbXEPXeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbXEPXeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbXEPXeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:34:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53261 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756534AbXEPXef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:34:35 -0400
Date: Thu, 17 May 2007 09:34:19 +1000
From: David Chinner <dgc@sgi.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [2/3] 2.6.22-rc1: known regressions v2 - XFS
Message-ID: <20070516233419.GP85884050@sgi.com>
References: <464B6743.9000607@googlemail.com> <464B6A2B.9020703@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B6A2B.9020703@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 10:31:39PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc1.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> File systems
> 
> Subject    : 2.6.21-git10/11: files getting truncated on xfs
> References : http://lkml.org/lkml/2007/5/9/410
> Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
> Handled-By : David Chinner <dgc@sgi.com>
> Patch      : http://lkml.org/lkml/2007/5/12/93
> Status     : patch was suggested

Jeremy has tentatively indicated that the patch has fixed the problem.
Have you seen any more problems since applying the patch, Jeremy?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
