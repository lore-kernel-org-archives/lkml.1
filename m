Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbXGRRbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbXGRRbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXGRRbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:31:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbXGRRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:31:07 -0400
Date: Wed, 18 Jul 2007 10:30:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Artem Bityutskiy <dedekind@infradead.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT-PULL] pull from UBI git
In-Reply-To: <1184762389.3531.168.camel@sauron>
Message-ID: <alpine.LFD.0.999.0707181027571.27353@woody.linux-foundation.org>
References: <1184762389.3531.168.camel@sauron>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Artem Bityutskiy wrote:
> 
> please pull from upstream branch of
> git://git.infradead.org/~dedekind/ubi-2.6.git to receive the following
> updates:

Please don't hide the branch name in the free-flowing text, and instead 
write your "please pull" messages like this:

   Please pull the upstream branch from

	git://git.infradead.org/~dedekind/ubi-2.6.git upstream

  to receive the following updates:

so that I don't miss the right branch-name even by mistake.

I try to be careful, and I think I missed the branch-name just once (and 
noticed it when the diffstat didn't match), but this is something I want 
to teach every git user to know very intimately: make it impossible to 
make mistakes, by always keeping the whole git information together, and 
never mixed up with any free-flowing explanation.

Pulled. Thanks,

		Linus
