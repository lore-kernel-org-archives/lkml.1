Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYFVXGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYFVXGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 19:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYFVXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 19:06:14 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58910 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754103AbYFVXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 19:06:13 -0400
Date: Mon, 23 Jun 2008 00:06:01 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, wim@iguana.be
Subject: Re: [patch 2/3] WATCHDOG: Clean out header of s3c2410_wdt driver.
Message-ID: <20080622230601.GD21835@fluff.org.uk>
References: <20080622213648.343882522@fluff.org.uk> <20080622213721.925217733@fluff.org.uk> <20080622233516.0a233c61@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622233516.0a233c61@lxorguk.ukuu.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 11:35:16PM +0100, Alan Cox wrote:
> On Sun, 22 Jun 2008 22:36:50 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > Remove the changelog from the top of the driver, which
> > is redundant as this information is more accurately
> > represented from the revision control holding the
> > file.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> NAK. This is going to clash with the big pile of changes stuck in the
> maintainers in queue.

Then why, as the original driver authour and current maintainer
do I not get told about this? This isn't the first time I've come
to apply this sort of thing and find that someone else has slipped
in an 'trivial' change such as whitespace that breaks an entire
patch series.

Do people not bother to check who wrote the driver or who is the
current maintainer before doing these things?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
