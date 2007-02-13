Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbXBNAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbXBNAF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbXBNAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:05:59 -0500
Received: from mga06.intel.com ([134.134.136.21]:23741 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932072AbXBNAF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:05:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,164,1170662400"; 
   d="scan'208"; a="196439922:sNHT20521291"
Message-ID: <45D24873.10308@linux.intel.com>
Date: Tue, 13 Feb 2007 15:23:31 -0800
From: James Ketrenos <jketreno@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel PRO/Wireless
 3945ABG
References: <45CCE3CA.4050904@linux.intel.com> <20070210004620.GA5959@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070210004620.GA5959@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Norbert Preining wrote:
...
> Ahhh ... one thing: The LED on my Acer Laptop (TM3012) does not show up,
> maybe because I have CONFIG_D80211_LEDS off?

The LED code in iwlwifi isn't hooked up to the D80211 LED code yet.  If 
you'd file a bug at http://bughost.org regarding the LEDs being broken 
(if you haven't already) I would appreciate it.

Thanks,
James
