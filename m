Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYG3PAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYG3PAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYG3O74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:59:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:47418 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751550AbYG3O7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:59:55 -0400
Date: Wed, 30 Jul 2008 16:59:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Sterba <dsterba@suse.cz>,
       Jiri Kosina <jkosina@suse.cz>, James.Bottomley@HansenPartnership.com
Subject: Re: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
	error: invalid use of undefined type 'struct ipw_network'
Message-ID: <20080730145953.GA15151@ds.suse.cz>
Reply-To: dsterba@suse.cz
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu> <20080728213532.GA24744@elte.hu> <20080728214153.GA30511@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728214153.GA30511@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry for the build error and thank you all for prompt fix.

It was not a last-moment change, the patches were waiting a
few weeks for the merge window. Hm, I probably did not test this
one, will do better next time.

Dave

