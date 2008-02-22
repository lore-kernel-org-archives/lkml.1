Return-Path: <linux-kernel-owner+w=401wt.eu-S936186AbYBVOZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186AbYBVOZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762952AbYBVOYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:24:44 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36838 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760228AbYBVOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:24:42 -0500
Message-ID: <47BEDB3F.4090100@davidnewall.com>
Date: Sat, 23 Feb 2008 00:55:03 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Glenn Streiff <gstreiff@neteffect.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Faisal Latif <flatif@neteffect.com>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>	 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>	 <20080221154951.GA28328@cs181133002.pp.htv.fi>	 <adahcg2awag.fsf@cisco.com>	 <20080221210124.GD28328@cs181133002.pp.htv.fi>	 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>	 <m3tzk1q3rt.fsf@maximus.localdomain>	 <47BE2985.6020305@davidnewall.com> <e2e108260802220429l5857c3edj351246ee31dd2a3e@mail.gmail.com>
In-Reply-To: <e2e108260802220429l5857c3edj351246ee31dd2a3e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> There is a reason to limit line length: scientific research has shown
> that readability of regular texts is optimal for a line length between
> 55 and 65 characters.

Putting aside the point that we're talking code, not regular text, I've
heard that said before and I don't think it's quite like that.  Perhaps
the numbers you said might assume various things such as the width of
the eye's field of view, the distance to the image and the size of each
character?


>  My experience is that the readability of source
> code decreases when the lines are very long (more than 160
> characters).

The point is that the width, excluding leading and trailing white space,
is what really matters.  Even deeply indented code can be a snap to
understand if you don't have to fight artificial line breaks.  And we've
got a much wider -- and taller! -- space available than we had in the
old 80x24 (and 80x1) days.
