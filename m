Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbXKTKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbXKTKVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXKTKVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:21:04 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60343 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXKTKVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:21:03 -0500
Message-ID: <4742B3EE.70000@keyaccess.nl>
Date: Tue, 20 Nov 2007 11:16:14 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>
Subject: Re: [PATCH 0/3] PNP cleanups
References: <1195552267.23700.163.camel@queen.suse.de>
In-Reply-To: <1195552267.23700.163.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-11-07 10:51, Thomas Renninger wrote:

> I wonder whether these rather large cleanups can already be added to
> some mainline branch.
> 
> There should be no functional change.
> 
> This could make life easier for me (not that bad, there were not that
> much changes in the past), but mainly make it easier for others to test
> the real patch, that should reduce memory waste in pnp layer and I
> expect some testing (especially on older isa machines) will be
> necessary...

I can volunteer some ISA-PnP testing.

> The intend is to unify the pnp_{port,mem,dma,irq}_... macros exposed in
> include/linux/pnp.h and make use of them more consequently.
> 
> The patches apply on 2.6.24-rc2-mm1

Patches against the current -stable are generally easiest for me as my ISA
test machines are slow enough to not enjoy frantically keeping up with the
absolute latest and greatest on them -- but I guess I'll manage.

Rene.

