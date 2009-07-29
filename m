Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZG2VDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZG2VDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZG2VC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:02:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59818 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZG2VC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:02:59 -0400
Date: Wed, 29 Jul 2009 23:02:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>, linux@arm.linux.org.uk,
       alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] Add support for LZO-compressed kernels on x86
Message-ID: <20090729210257.GA22975@merkur.ravnborg.org>
References: <1248271279-9920-1-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-2-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-3-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-4-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-5-git-send-email-albin.tonnerre@free-electrons.com> <4A70AA64.4020301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A70AA64.4020301@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 01:00:36PM -0700, H. Peter Anvin wrote:
> On 07/22/2009 07:01 AM, Albin Tonnerre wrote:
> > This is the third and last part of the patch, which contains the
> > necessary changes to the x86 Kconfig and boot/compressed to allow the
> > use of this new compression method
> > 
> > Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> Since the patchset otherwise isn't really x86-related it probably makes
> more sense to pass this through the kbuild tree, or perhaps via akpm,
> rather than -tip?

I can take it via kbuild if I get a fewsh patch-set with proper
ack's added.
I've long lost the original patch-set.

	Sam
