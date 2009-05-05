Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZEETAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZEETAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZEETAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:00:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58762
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557AbZEETAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:00:39 -0400
Date: Tue, 05 May 2009 12:00:34 -0700 (PDT)
Message-Id: <20090505.120034.213663073.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-05-05
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090505181009.GA2788@tuxdriver.com>
References: <20090505181009.GA2788@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 5 May 2009 14:10:09 -0400

> Yet another round of fixes intended for 2.6.30...
> 
> Included is the removal of another unnecessary EXPORT_SYMBOL that seems
> to be irritating some versions of GCC, the correction of a WARN_ON check
> that generates spurious log noise, a fix for a missing length value that
> leads to bad data being passed to userland, the correction of a WARN in
> iwl_set_tkip_dynamic_key_info, fixes for a couple of cfg80211 Oopsen, a
> one-line comment correction in cfg80211, and a couple of memory
> corruption fixes related to mac80211 rate control algorithms.  One of
> these last two looks a little big, but it is mostly moving a hunk of
> code around.
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Pulled, thanks!
