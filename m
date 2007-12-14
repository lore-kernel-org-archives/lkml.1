Return-Path: <linux-kernel-owner+w=401wt.eu-S1765429AbXLNKrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765429AbXLNKrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXLNKrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:47:31 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:37224 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbXLNKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:47:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 11:45:11 +0100
User-Agent: KMail/1.9.6
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de,
       John Linville <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712140143.16451.mb@bu3sch.de> <1197593750.898.34.camel@brick>
In-Reply-To: <1197593750.898.34.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141145.12442.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 01:55:50 Harvey Harrison wrote:
> On Fri, 2007-12-14 at 01:43 +0100, Michael Buesch wrote:
> > Oh come on. b43 is more than a year old now. How long should we wait?
> > Two or three? Forever?
> > 
> 
> Any pointers to the advantages of b43?

http://www.linuxwireless.org/en/users/Drivers/b43

-- 
Greetings Michael.
