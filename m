Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbXISPjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbXISPjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbXISPiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:38:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52250 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbXISPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:38:51 -0400
Date: Wed, 19 Sep 2007 17:38:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-ID: <20070919153848.GA17005@one.firstfloor.org>
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F12ED7.3060605@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with you; however, this is in the example code in the 
> Documentation directory,  It is not part of the trace code.  The example 
> was just meant to be a demonstration of how the interface works.

That's not a good excuse.  In fact it's a very bad one.
Especially example code needs to be correct because it'll be likely copied 
a lot.

-Andi
