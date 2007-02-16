Return-Path: <linux-kernel-owner+w=401wt.eu-S1160999AbXBPOEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160999AbXBPOEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161001AbXBPOEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:04:33 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4323 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160999AbXBPOEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:04:32 -0500
Date: Fri, 16 Feb 2007 09:04:03 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: v j <vj.linux@gmail.com>
Cc: Trent Waddington <trent.waddington@gmail.com>,
       David Lang <david.lang@digitalinsight.com>,
       Scott Preece <sepreece@gmail.com>, Miguel Ojeda <maxextreme@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070216140403.GA20771@hmsreliant.homelinux.net>
References: <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com> <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com> <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com> <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz> <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com> <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com> <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 10:25:12PM -0800, v j wrote:
> >It's written in black and white, in the license.
> 
> Please point me to where it says I cannot load proprietary modules in
> the Kernel.
> 
It doesn't, but EXPORT_SYMBOL_GPL makes it quite clear what you can not do if
you are not a GPL module.

> > Apart from that,
> >Greg KH has made his opinion clear, and you have said you understand
> >and don't debate that he holds this opinion, and his code is what you
> >said you were linking to (the sysfs/class stuff), so why do you keep
> >saying that "it is not clear".
> 
> I know his opinion. I don't debate his opinion. It is his code. I
> choose not to use his code because of the license issue.
> 
Then choose not to use it and move on, rather than lamenting the fact that
your life is more difficult because of his decision

> >Do you think that, somehow, Linus' opinion trumps Greg KH's opinion on
> >his own code?
> 
> No, just that the trend is disturbing. If enough Kernel Developers
> choose to write their Software in a way that prevents others from
> using it freely, then that is troubling. Especially when these Kernel
> Developers are substituting existing interfaces in the Kernel with
> ones that are NEW and require specific licenses.
> 
Its disturbing to you, and you alone.  If you stopped using Linux today because
of this, no one would miss you.  If enough like-minded people did this, you
would all be using your business model, and th F/OSS community would continue on
its way.  You appear to think that the community relies on people who make
drivers in you're model, and thats simply not the case.

Neil

> vj.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
