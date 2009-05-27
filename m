Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZE0UkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZE0UkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZE0UkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:40:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35637
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbZE0UkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:40:06 -0400
Date: Wed, 27 May 2009 13:40:06 -0700 (PDT)
Message-Id: <20090527.134006.241271867.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jeremy@goop.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, jens.axboe@oracle.com, chrisw@redhat.com,
       kurt.hackel@oracle.com, akpm@linux-foundation.org,
       ksrinivasan@novell.com, jbeulich@novell.com, avi@redhat.com,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 17/17] xen: disable MSI
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	<1243409850-21577-18-git-send-email-jeremy@goop.org>
	<alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 May 2009 08:34:22 -0700 (PDT)

> I hate them. They are stupid. 90% of all the impact lines I see are either 
> (a) misleading or (b) totally inane and pointless. 

I just delete any Impact lines I see in patches sent to me, and I
honestly suggest you do so as well.

Really.
