Return-Path: <linux-kernel-owner+w=401wt.eu-S1423439AbXBPJNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423439AbXBPJNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423440AbXBPJM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:12:59 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:10948 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423439AbXBPJM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:12:58 -0500
X-ME-UUID: 20070216091256168.293CE1C00089@mwinf1928.orange.fr
Subject: Re: GPL vs non-GPL device drivers
From: Xavier Bestel <xavier.bestel@free.fr>
To: v j <vj.linux@gmail.com>
Cc: David Lang <david.lang@digitalinsight.com>,
       Scott Preece <sepreece@gmail.com>, Miguel Ojeda <maxextreme@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
	 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
	 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
	 <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 10:12:50 +0100
Message-Id: <1171617170.5835.101.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 21:48 -0800, v j wrote:
> We only get crap because no one here yet knows how to interpret
> proprietary modules loaded into the kernel.

The proprietary modules where only a tiny wrapper is linux-specific and
the rest is cross-platform are in a grey area, yes.
But your modules, written specifically for linux but distributed as
binary-only, are specifically what the people choosing the GPL want to
avoid. They are a derivative work, and are, as such, illegal under the
GPL.

As stated by multiple other people, please consult a lawyer if you want
to be nasty. Or just play by the rules.

	Xav


