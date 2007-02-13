Return-Path: <linux-kernel-owner+w=401wt.eu-S1750798AbXBMN6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798AbXBMN6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXBMN6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:58:49 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:37529 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750791AbXBMN6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:58:48 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Tue, 13 Feb 2007 15:58:47 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <45CCE3CA.4050904@linux.intel.com>
In-Reply-To: <45CCE3CA.4050904@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131558.48987.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 23:12:42 James Ketrenos wrote:
> Please hold all questions until I am done with this email.  Thank you.
>
> We are pleased to announce the availability of a new driver for the
> Intel PRO/Wireless 3945ABG Network Connection adapter.  This new driver
> uses the new d80211 subsystem previously only available as part of the
> wireless-dev tree.
>
> You can find the new driver, and additional information about it, here:
>
>    http://intellinuxwireless.org/iwlwifi.

Tried this is on a patched 2.6.20 kernel with ipw3945 device and it always 
puts the card in 802.11a mode instead of 802.11bg mode.

Ideas?

Regards,
ismail
