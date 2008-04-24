Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYDXEXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYDXEXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYDXEXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:23:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50007
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbYDXEXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:23:06 -0400
Date: Wed, 23 Apr 2008 21:23:06 -0700 (PDT)
Message-Id: <20080423.212306.12843642.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] linux/atm_tcp.h: cleanup for userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804232333.10968.vapier@gentoo.org>
References: <200804232303.52427.vapier@gentoo.org>
	<20080423.201844.167236025.davem@davemloft.net>
	<200804232333.10968.vapier@gentoo.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 23 Apr 2008 23:33:10 -0400

> On Wednesday 23 April 2008, David Miller wrote:
> > But you're adding an include of another file that has the problem
> > you're supposedly fixing.
> 
> and i'll send out fixes for that file in time.

Please combine the two changes, so that we actually fix the
problem.

Thank you.
