Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914Ab0A1F7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0A1F7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 00:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191Ab0A1F7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 00:59:33 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:44996 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0A1F7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 00:59:32 -0500
X-Greylist: delayed 804 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 00:59:32 EST
Subject: Re: PROBLEM: reproducible crash KVM+nf_conntrack all recent 2.6
 kernels
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
In-Reply-To: <1264657559.2793.103.camel@tonnant>
References: <1264657559.2793.103.camel@tonnant>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 28 Jan 2010 00:59:24 -0500
Message-Id: <1264658364.2793.105.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 00:46 -0500, Jon Masters wrote:

> A number of people seem to have reported this crash in various forms,
> but I have yet to see a solution, and can reproduce on 2.6.33-rc5 this
> evening so I know it's still present in the latest upstream kernels too.
> Userspace is Fedora 12, and this happens on both all recent F12 kernels
> (sporadic in 2.6.31 until recently, solidly reproducible on 2.6.32) and
> upstream 2.6.32, and 2.6.33-rc5 also - hard to find a "known good".

Now I can capture the panic()s, I'm rebuilding the 2.6.33-rc5 kernel
with some better debugging options to at least get some more data.

Jon.


