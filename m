Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXFPQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXFPQtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXFPQto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:49:44 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:50048 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbXFPQtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:49:43 -0400
Date: Sat, 16 Jun 2007 12:49:31 -0400
To: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
Cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, alan <alan@clueserver.org>,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070616164931.GF14788@delft.aura.cs.cmu.edu>
Mail-Followup-To: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	alan <alan@clueserver.org>, hpa@zytor.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <46739B2C.4080606@hawkeye.stone.uk.eu.org> <4673B15B.2080300@wolfmountaingroup.com> <4673B77E.1000803@wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4673B77E.1000803@wolfmountaingroup.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 04:12:14AM -0600, Jeffrey V. Merkey wrote:
> Jeffrey V. Merkey wrote:
> >over).  There's also another patent filed as well.  It's a noble 
> >effort to do a free version, but be aware there's some big guns with 
> >patents out there already, not to mention doing this is complex beyond 
> >belief.
>
> I reviewed your sample implementation, and it appears to infringe 3 
> patents already.    You should do some research on this.  ~~~~

First of all, you are responding to someone in the UK, I thought they
didn't even have software patents over there. Second, I didn't see any
implementation, just a high level description. Finally advising anyone
(who is not an actual patent lawyer that could correctly interpret the
language and scope of a patent) to go search out patents seems pretty
bad advice. That can only result in not even attempting to research some
potentially new and innovative approach.

Researching prior published work in the area is considerably more
helpful. Especially when something is complex beyond belief it has
probably attracted various researchers over time and there are most
likely various different solutions that have been explored previously.
Such existing work can form a good basis for further work.

Finally, even if there are patents they could be too limited in scope,
overly broad, can be invalidated due to prior art. It may also be
possible that a patent holder has no problem granting a royalty free
license for a GPL licensed implementation.

Jan

