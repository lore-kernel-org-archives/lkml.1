Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbXBPPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbXBPPkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932394AbXBPPkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:40:33 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:35225 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932403AbXBPPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:40:32 -0500
Date: Fri, 16 Feb 2007 10:40:31 -0500
To: v j <vj.linux@gmail.com>
Cc: Trent Waddington <trent.waddington@gmail.com>,
       David Lang <david.lang@digitalinsight.com>,
       Scott Preece <sepreece@gmail.com>, Miguel Ojeda <maxextreme@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070216154031.GR7584@csclub.uwaterloo.ca>
References: <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com> <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com> <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com> <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz> <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com> <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com> <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 10:25:12PM -0800, v j wrote:
> Please point me to where it says I cannot load proprietary modules in
> the Kernel.

Some people consider modules derivative works, since they link with
pieces of the kernel.  Distributing derivative works are considered
distributing the original work, which means the GPL applies to the
result.

> I know his opinion. I don't debate his opinion. It is his code. I
> choose not to use his code because of the license issue.
> 
> No, just that the trend is disturbing. If enough Kernel Developers
> choose to write their Software in a way that prevents others from
> using it freely, then that is troubling. Especially when these Kernel
> Developers are substituting existing interfaces in the Kernel with
> ones that are NEW and require specific licenses.

devfs had issues.  Someone (Greg) provided something better.  devfs went
away when nothing in the kernel needed it anymore.  That something
outside the kernel was using devfs, well who cares.  That is the outside
code's problem if they don't keep up.  If they happen to have any issues
with the replacement system, then that too is their problem and only
their problem.

--
Len Sorensen
