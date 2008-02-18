Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYBRXtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYBRXtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYBRXtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:49:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYBRXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:49:24 -0500
Date: Mon, 18 Feb 2008 15:49:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lachlan McIlroy <lachlan@sgi.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
In-Reply-To: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com>
Message-ID: <alpine.LFD.1.00.0802181547560.7833@woody.linux-foundation.org>
References: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Feb 2008, Lachlan McIlroy wrote:
> 
> This will update the following files:
> 
>  fs/xfs/Kbuild             |    6 --
>  fs/xfs/Makefile           |  118 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/Makefile-linux-2.6 |  117 --------------------------------------------
>  3 files changed, 117 insertions(+), 124 deletions(-)
>  delete mode 100644 fs/xfs/Kbuild

Hmm. This didn't actually remove the old Makefile-linux-2.6 file, so it 
exists as a zero-length file still.

Was that intentional?

		Linus
