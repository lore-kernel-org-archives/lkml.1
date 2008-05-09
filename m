Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYEIPGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYEIPGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYEIPG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:06:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbYEIPGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:06:25 -0400
Date: Fri, 9 May 2008 08:05:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <4824606E.3040409@garzik.org>
Message-ID: <alpine.LFD.1.10.0805090805210.3142@woody.linux-foundation.org>
References: <20080508.171408.94456716.davem@davemloft.net> <alpine.LFD.1.10.0805081848170.2940@woody.linux-foundation.org> <4824606E.3040409@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Jeff Garzik wrote:
> 
> The e1000e change is just a bunch of code additions for a new phy type, not a
> bunch of /changes/ really.  Is that the change you're concerned with?

Yes. I saw 800 new lines to a driver I use, and I go "Ugh".

		Linus
