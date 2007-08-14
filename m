Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXHNHNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXHNHNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXHNHMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:12:54 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41847 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXHNHMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:12:53 -0400
Date: Tue, 14 Aug 2007 09:09:01 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Karl Meyer <adhocrocker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Message-ID: <20070814070901.GA14693@electric-eye.fr.zoreil.com>
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com> <20070813165821.GA19356@electric-eye.fr.zoreil.com> <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Meyer <adhocrocker@gmail.com> :
[...]
> dmesg, interrupts and .config are attached. I will have a look at git bisect.

Can you reproduce the problem when nvidia binary-only stuff is not loaded
after boot ?

-- 
Ueimor
