Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZJ3NrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZJ3NrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZJ3NrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:47:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbZJ3NrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:47:04 -0400
Date: Fri, 30 Oct 2009 09:46:39 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Takashi Iwai <tiwai@suse.de>
Cc: Julia Lawall <julia@diku.dk>, Kyle McMartin <kyle@mcmartin.ca>,
       Jaroslav Kysela <perex@perex.cz>, linux-parisc@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/14] sound/parisc: Move dereference after NULL test
Message-ID: <20091030134639.GZ11702@bombadil.infradead.org>
References: <Pine.LNX.4.64.0910170833240.9213@ask.diku.dk> <s5hhbthywjl.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbthywjl.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 12:02:22PM +0100, Takashi Iwai wrote:
> At Sat, 17 Oct 2009 08:33:47 +0200 (CEST),
> Julia Lawall wrote:
> > 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Applied this one, too.  Thanks.
> 
> 

Great, thanks Takashi!

cheers, Kyle
