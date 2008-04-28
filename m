Return-Path: <linux-kernel-owner+w=401wt.eu-S937839AbYD1VHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937839AbYD1VHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933790AbYD1VHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:07:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39463 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934619AbYD1VHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:07:33 -0400
Date: Mon, 28 Apr 2008 23:08:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/3] fix choice dependency check
Message-ID: <20080428210806.GF18248@uranus.ravnborg.org>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com> <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com> <20080226194058.GA31438@uranus.ravnborg.org> <Pine.LNX.4.64.0802290509100.2723@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802290509100.2723@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 05:10:24AM +0100, Roman Zippel wrote:
> 
> Properly check the dependency of choices as a group.
> Also fix that sym_check_deps() correctly terminates the dependency loop 
> error check (otherwise it would continue printing the dependency chain).
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Hi Roman.

I realised this was never applied - so I did so now.
Same with the one with named choice groups.

	Sam
