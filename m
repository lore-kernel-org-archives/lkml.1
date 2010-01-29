Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203Ab0A2K5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0A2K5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227Ab0A2K5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:57:46 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:40237 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0A2K5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:57:45 -0500
Subject: Re: PROBLEM: reproducible crash KVM+nf_conntrack all recent 2.6
 kernels
From: Jon Masters <jonathan@jonmasters.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
In-Reply-To: <1264756232.3184.10.camel@edumazet-laptop>
References: <1264657559.2793.103.camel@tonnant>
	 <1264658364.2793.105.camel@tonnant>  <4B6180D1.6050609@trash.net>
	 <1264720891.2793.205.camel@tonnant>  <1264727492.2793.207.camel@tonnant>
	 <1264754565.2793.405.camel@tonnant>
	 <1264756232.3184.10.camel@edumazet-laptop>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 29 Jan 2010 05:57:35 -0500
Message-Id: <1264762655.2793.409.camel@tonnant>
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

On Fri, 2010-01-29 at 10:10 +0100, Eric Dumazet wrote:

> Jon, do you have multiple network namespace active on your machine, when
> crash occurs ?

I don't believe so. I just built in Jason's latest kgdb/kdb patches and
am going to give them a whirl to see if I can get anything more out of
this panic than I currently have.

Jon.


