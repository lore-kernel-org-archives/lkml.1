Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZKEO6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZKEO6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZKEO6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:58:06 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:2794 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757823AbZKEO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:58:05 -0500
Date: Thu, 5 Nov 2009 17:58:09 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20091105145809.GA24319@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
 <AB7471E8-F924-418B-83A3-2DC48CC707CA@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AB7471E8-F924-418B-83A3-2DC48CC707CA@kernel.crashing.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 08:49:38AM -0600, Kumar Gala wrote:
> 
> On Jul 13, 2009, at 10:19 AM, Anton Vorontsov wrote:
> 
> >Hi all,
> >
> >I've been sitting on these patches for some time, but now it appears
> >that the set_sync() feature is needed elsewhere. So here are the
> >patches.
> >
> >Joakim, I think this is what you need.
> >
> >Thanks,
> 
> What this resolved or dropped?

That was something like an RFC. There are no mainline users for
this support (yet), so we can drop it for now.

Thanks,

p.s.

As David didn't comment on the patches, I'd assume there are no
strong objections against this feature if we'll want to mainline
the support in future. ;-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
