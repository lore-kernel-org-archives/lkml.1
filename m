Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbZDGB1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbZDGB1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZDGB1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:27:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbZDGB1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:27:24 -0400
Date: Mon, 6 Apr 2009 18:25:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20090406.175752.236260059.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0904061824410.4010@localhost.localdomain>
References: <20090406.175752.236260059.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The sky2 driver is buggered (by the previous pull, I presume). Some PCI 
interaction. NULL pointer dereference at boot.

		Linus
