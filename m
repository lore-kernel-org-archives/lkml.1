Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXKUX4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXKUX4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 18:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXKUX4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 18:56:04 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:57209 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbXKUX4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 18:56:03 -0500
Date: Thu, 22 Nov 2007 00:53:23 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Wagner Ferenc <wferi@niif.hu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: network driver usage count
Message-ID: <20071121235323.GA409@electric-eye.fr.zoreil.com>
References: <87hcjf9yd4.fsf@tac.ki.iif.hu> <20071121130445.569d2176@freepuppy.rosehill> <87myt7nt0k.fsf@szonett.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87myt7nt0k.fsf@szonett.ki.iif.hu>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wagner Ferenc <wferi@niif.hu> :
[...]
> So why can I remove a driver serving live network traffic?

Why not ? It is quite common to remove physically a network/storage
device. 

-- 
Ueimor
