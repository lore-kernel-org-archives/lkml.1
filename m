Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZKLOYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZKLOYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZKLOYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:24:04 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:45328 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZKLOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:24:04 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Date: Thu, 12 Nov 2009 15:26:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <20091112103639.GB24684@elte.hu> <4AFBEA4B.4070100@kernel.org>
In-Reply-To: <4AFBEA4B.4070100@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911121526.36583.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. November 2009 11:58:19 schrieb Tejun Heo:

> While I agree this is a valid reason, I really don't think we should
> be restructuring whole code to accomodate long strings on single line.
> I think a better way would be to teach grepping tool to match those
> broken lines.  It shouldn't be too difficult to put this into ack[1]
> and maybe we can have git-ack (that's a bad name for git tho).  I'll
> ask ack author nicely.

There's a point where following style guidelines turns into a fetish.
Plain simple "grep" should work.

	Regards
		Oliver
