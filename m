Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYHCRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYHCRxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHCRxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:53:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYHCRxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:53:06 -0400
Date: Sun, 3 Aug 2008 10:52:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bugfixes/cleanups
In-Reply-To: <E1KPShM-0007Ks-M0@closure.thunk.org>
Message-ID: <alpine.LFD.1.10.0808031050450.3668@nehalem.linux-foundation.org>
References: <E1KPShM-0007Ks-M0@closure.thunk.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Aug 2008, Theodore Ts'o wrote:
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Could you please include the expected diffstat too?

I can match up the shortlog to the expected thing, and see that I got what 
you intended for me, but the thing I actually _care_ much more deeply 
about is that it only touched ext4 (and jbd2) in this case. So I like 
matching up the diffstat, with the shortlog being just secondary.

			Linus
