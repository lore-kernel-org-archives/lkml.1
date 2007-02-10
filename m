Return-Path: <linux-kernel-owner+w=401wt.eu-S1946820AbXBJBIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946820AbXBJBIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946821AbXBJBIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:08:39 -0500
Received: from alpha.logic.tuwien.ac.at ([128.130.175.20]:53375 "EHLO
	alpha.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946820AbXBJBIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:08:38 -0500
X-Greylist: delayed 1333 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 20:08:37 EST
Date: Sat, 10 Feb 2007 01:46:20 +0100
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Message-ID: <20070210004620.GA5959@gamma.logic.tuwien.ac.at>
References: <45CCE3CA.4050904@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45CCE3CA.4050904@linux.intel.com>
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Fre, 09 Feb 2007, James Ketrenos wrote:
> We are pleased to announce the availability of a new driver for the 
> Intel PRO/Wireless 3945ABG Network Connection adapter.  This new driver 

I am impressed: I had 2.6.20 running with ipw3945 + wpa_supplicant. I
installed the d80211 system and the new driver, rebooted, and you won't
believe it, I had network connection even with WEP encryption.

That was a big surprise for me that it worked out of the box without any
magic.

If you are interested in any dmesg/log output, please let me know.


Ahhh ... one thing: The LED on my Acer Laptop (TM3012) does not show up,
maybe because I have CONFIG_D80211_LEDS off?

Again, thanks a lot for the good work!

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>                    Università di Siena
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
HARPENDEN (n.)
The coda to a phone conversion, consisting of about eight exchanges,
by which people try gracefully to get off the line.
			--- Douglas Adams, The Meaning of Liff
