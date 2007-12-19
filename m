Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXLSBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXLSBTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXLSBTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:19:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150AbXLSBTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:19:08 -0500
Date: Tue, 18 Dec 2007 17:19:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
cc: Lachlan McIlroy <lachlan@sgi.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc6
In-Reply-To: <20071219004126.GS4396912@sgi.com>
Message-ID: <alpine.LFD.0.9999.0712181718430.21557@woody.linux-foundation.org>
References: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com> <20071219004126.GS4396912@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Dec 2007, David Chinner wrote:
>
> On Tue, Dec 18, 2007 at 05:59:11PM +1100, Lachlan McIlroy wrote:
> > Please pull from the for-linus branch:
> >     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> Linus, please don't pull this yet. A problem has been found in
> the dirent fix, and we've just fixed another mknod related regression
> so we've got another couple of fixes still to go in XFS for 2.6.24.
> 

Too late, it's already long since pulled.

		Linus
