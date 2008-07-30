Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbYG3PLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbYG3PLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762663AbYG3PLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:11:16 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36042 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762644AbYG3PLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:11:15 -0400
Subject: Re: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
	error: invalid use of undefined type 'struct ipw_network'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: dsterba@suse.cz
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20080730145953.GA15151@ds.suse.cz>
References: <20080727190601.GA764@elte.hu>
	 <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
	 <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com>
	 <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org>
	 <20080728205700.GA3613@elte.hu> <20080728213532.GA24744@elte.hu>
	 <20080728214153.GA30511@elte.hu>  <20080730145953.GA15151@ds.suse.cz>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 10:11:09 -0500
Message-Id: <1217430670.3335.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 16:59 +0200, David Sterba wrote:
> Hi,
> 
> I'm sorry for the build error and thank you all for prompt fix.

You're welcome, But ...

> It was not a last-moment change, the patches were waiting a
> few weeks for the merge window. Hm, I probably did not test this
> one, will do better next time.

I see the patches came in via a straight email sequence.  They really
need to be in a tree somewhere that's pulled into linux-next so this
type of thing gets noticed.  Since they're wireless patches, why not
send them through John Linville's wireless tree?

James


