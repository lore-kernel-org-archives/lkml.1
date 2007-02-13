Return-Path: <linux-kernel-owner+w=401wt.eu-S1750861AbXBMQ5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750861AbXBMQ5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXBMQ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:57:04 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:52169 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbXBMQ5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:57:01 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Tue, 13 Feb 2007 18:57:01 +0200
User-Agent: KMail/1.9.6
Cc: "James Ketrenos" <jketreno@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
References: <45CCE3CA.4050904@linux.intel.com> <200702131558.48987.ismail@pardus.org.tr> <b6a2187b0702130710s217281c4k5ed227995c09c878@mail.gmail.com>
In-Reply-To: <b6a2187b0702130710s217281c4k5ed227995c09c878@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702131857.02369.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 17:10:24 Jeff Chua wrote:
> On 2/13/07, Ismail Dönmez <ismail@pardus.org.tr> wrote:
> > Tried this is on a patched 2.6.20 kernel with ipw3945 device and it
> > always puts the card in 802.11a mode instead of 802.11bg mode.
> >
> > Ideas?
>
> Before running  "iwconfig wlan0 channel 8",  the card is set to
> 802.11a mode. iwconfig shows rate at 54Mb/s. But after setting the
> channel, it sets to 802.11b mode, and I can't find a way to change
> from 11Mb/s to 54MB/s.
>
> "iwlist eth0 rate" only show up to 11Mb/s.
>
> So, my problem is the card is always in 802.11b mode.

So I guess there is a common problem with a/bg modes?

Regards,
ismail


