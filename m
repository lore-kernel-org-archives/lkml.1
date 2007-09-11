Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbXIKVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbXIKVeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965458AbXIKVeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:34:01 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56729 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965111AbXIKVeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:34:00 -0400
Date: Tue, 11 Sep 2007 23:30:17 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org, shuchen@realtek.com.tw
Subject: Re: r8169: can't send magic packet for Wake-On-Lan
Message-ID: <20070911213017.GA661@electric-eye.fr.zoreil.com>
References: <1189545366.4403.9.camel@bip.parateam.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189545366.4403.9.camel@bip.parateam.prv>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel <xavier.bestel@free.fr> :
[...]
> with the r8169 I can't send a magic packet anymore. I'm using ethtool
> for that, with the previous one (an rtl8139b) it was working very well.
> ethtool -D apparently says it could send the packet ok.

I see no "-D" option in the sources from the git repository of ethtool.

Where did you find it ?

-- 
Ueimor
