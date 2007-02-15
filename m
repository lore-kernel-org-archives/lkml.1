Return-Path: <linux-kernel-owner+w=401wt.eu-S965861AbXBOLBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965861AbXBOLBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965627AbXBOLBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:01:07 -0500
Received: from smtp20.orange.fr ([80.12.242.27]:62945 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965861AbXBOLBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:01:05 -0500
X-ME-UUID: 20070215110103620.976AE1C00096@mwinf2011.orange.fr
Subject: Re: GPL vs non-GPL device drivers
From: Xavier Bestel <xavier.bestel@free.fr>
To: Mohammed Gamal <m.gamal005@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <52d4a3890702150251w7751da0cve55c6f2cf64e1b8e@mail.gmail.com>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070214231143.11ff6b46.rdunlap@xenotime.net>
	 <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
	 <1171533690.5835.40.camel@frg-rhel40-em64t-03>
	 <52d4a3890702150251w7751da0cve55c6f2cf64e1b8e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 12:00:56 +0100
Message-Id: <1171537256.5835.60.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 12:51 +0200, Mohammed Gamal wrote:
> I am still a kernel newbie, and I am still not very much aware about
> the GPL vs. Non-GPL drivers debate. I personally think it'd be better
> that all drivers should be GPL'd but if that's the case, what would be
> the legal position of such vendors as ATI or NVIDIA who supply closed
> source drivers? Would it be illegal to use them?

Yeah, this is a recurrent debate, and the positions are mixed. Linus
said that the nvidia driver isn't developed only for linux but also for
windows, so it's not a true derivative of the kernel, so the GPL doesn't
really apply. But not everyone (I mean core developpers) fully agrees
IIRC.
But that's not the case with VJ's drivers, which are apparently solely
for linux, so should be distributed under the GPL.

	Xav


