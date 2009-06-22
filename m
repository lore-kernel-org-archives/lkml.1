Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZFVRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZFVRkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZFVRkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:40:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50827 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZFVRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:40:06 -0400
Date: Mon, 22 Jun 2009 19:40:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: iwl3945 in 2.6.31-rc0: ad-hoc mode broken?
Message-ID: <20090622174002.GD21299@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz> <1245692380.24303.494.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245692380.24303.494.camel@rc-desk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 10:39:40, reinette chatre wrote:
> Hi Pavel,
> 
> On Fri, 2009-06-19 at 15:24 -0700, Pavel Machek wrote:
> > Hi!
> > 
> > I tried using ad-hoc mode (against t-mobile G1) on -rc0, and was
> > unsuccessful -- never got dhcp. I had to reboot back to
> > 2.6.30... Should I try it few more times or is something broken?
> > 
> > (Also wifi LED stopped working on x60, but that's older issue).
> > 
> 
> Are you testing Linus's repo here? Should we not maybe wait with testing
> until -rc1 is released?

WTF? Yes, I am testing Linus' tree (hence 2.6.31-rc0). I thought
2.6. stable series is expected to work at all times, and it is bug if
it does not (otherwise git bisect is useless). Did you intentionally
break the tree or what? Or do you have fixes pending?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
