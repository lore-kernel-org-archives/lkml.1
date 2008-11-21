Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYKUOod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYKUOod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYKUOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:44:25 -0500
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:50252
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYKUOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:44:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=n-_EF0tFy-QA:10 a=zn7U-nhvGoYA:10
 a=2iNgh9swn-kA:10 a=EHYkf4x39Nvm60-2uisA:9 a=FaU2_Ki9l2_Ipb1iZtaDaqtFq6IA:4
 a=d4CUUju0HPYA:10 a=5WZzfXpOq_gA:10
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4924A289.6030906@euromail.se>
References: <49142351.9080805@euromail.se>
	 <20081119113508.ZZRA012@mailhub.coreip.homeip.net>
	 <1227113699.7181.103.camel@jg-vaio>  <4924A289.6030906@euromail.se>
Content-Type: text/plain
Organization: One Laptop Per Child
Date: Fri, 21 Nov 2008 09:43:44 -0500
Message-Id: <1227278624.7218.16.camel@jg-vaio>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting....  I know of the a different case: a device which
certainly does not report ellipses, rather reports x, y, dx, dy.
                          - Jim


On Thu, 2008-11-20 at 00:34 +0100, Henrik Rydberg wrote:
> Jim Gettys wrote:
> [...]
> > Also, I'm still concerned about using elipses. I doubt very much any
> > hardware will ever be reporting elipses; more likely are parallelograms,
> > or trapezoids, other simple geometric figures, rather than a center with
> > size and orientation.
> 
> The bcm5974 chip is doing precisely this.
> 
> Henrik
> 
-- 
Jim Gettys <jg@laptop.org>
One Laptop Per Child

