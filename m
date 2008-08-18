Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbYHRStd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbYHRStd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbYHRStE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:49:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbYHRStD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:49:03 -0400
Date: Mon, 18 Aug 2008 11:48:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: greg@kroah.com, mingo@elte.hu, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable 1/2] x86-64: Clean up save/restore_i387() usage
In-Reply-To: <20080818183605.719267000@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0808181146540.3324@nehalem.linux-foundation.org>
References: <20080818183605.719267000@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Aug 2008, Suresh Siddha wrote:
>
> [Upstream commit: b30f3ae50cd03ef2ff433a5030fbf88dd8323528]

And it's authorship got destroyed by you.

Please guys, add teh proper "From:" line at the top. Don't forward patches 
like this unattributed. It doesn't matter if they are trivial or not, it's 
just really bad form. 

			Linus
