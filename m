Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbXHFVHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbXHFVHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbXHFVHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:07:16 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46044 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760498AbXHFVHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:07:14 -0400
Date: Mon, 6 Aug 2007 23:06:37 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Bram <bram@linux.kernel.as.avontuur.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Possible bug in realtek 8169 ethernet driver
Message-ID: <20070806210637.GA18611@electric-eye.fr.zoreil.com>
References: <20070805155915.GM2761@avontuur.org> <20070805213557.GA21500@electric-eye.fr.zoreil.com> <20070806133752.GN2761@avontuur.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806133752.GN2761@avontuur.org>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bram <bram@linux.kernel.as.avontuur.org> :
[...]
> The device now works! But, it still comes up as eth2 instead of eth0,
> even though it's first detected as eth0. There are no other network

Check the udev rules and/or your init scripts ?

-- 
Ueimor
