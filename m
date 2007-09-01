Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbXIAU5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbXIAU5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbXIAU46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:56:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2610 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbXIAU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:56:57 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: eranian@hpl.hp.com,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <200709012232.25609.ak@suse.de>
References: <20070828194636.GB2814@frankl.hpl.hp.com>
	 <200709011219.49256.ak@suse.de> <20070901195142.GA9778@frankl.hpl.hp.com>
	 <200709012232.25609.ak@suse.de>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 13:46:28 -0700
Message-Id: <1188679588.11196.16.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 22:32 +0200, Andi Kleen wrote:
> On Saturday 01 September 2007 21:51:42 Stephane Eranian wrote:
> > Hello,
> > 
> > Here is a patch to fix the NMI watchdog problem on CoreDuo processor.
> > I think we still need Daniel's patch to make the error path (when you
> > are stuck) do the right cleanup.
> 
> Thanks.
> 
> Can that other patch please be submitted too? 

I just submitted it, subject was 

"i386: fix a hang on stuck nmi watchdog"

Daniel

