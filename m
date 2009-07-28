Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZG1Fxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZG1Fxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZG1Fxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:53:31 -0400
Received: from mail.farrellit.net ([66.191.143.114]:36659 "EHLO spore.ath.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZG1Fxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:53:31 -0400
Date: Tue, 28 Jul 2009 00:53:30 -0500
From: Dan Farrell <dan@spore.ath.cx>
To: linux-kernel@vger.kernel.org
Subject: Re: Rtl8187se & 2.6.30.3 - almost, but no wpa
Message-ID: <20090728005330.09e22542@pascal.spore.ath.cx>
In-Reply-To: <20090728001238.597a670e@pascal.spore.ath.cx>
References: <609821868-1248721321-cardhu_decombobulator_blackberry.rim.net-1499766221-@bxe1208.bisx.prod.on.blackberry>
	<20090728001238.597a670e@pascal.spore.ath.cx>
Organization: Spore, Ltd.
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 27 Jul 2009 19:02:02 +0000
> "Dan Farrell" <Dan@spore.ath.cx> wrote:

> note that RSN IE in Beacon/ProbeResp does not match WPA: RSN IE in 3/4
> msg.  in the second to last byte, the former shows 00 and the later
> shows 0c.  

Internet suggests disabling WME in hostapd (supplying my testing access
point).  wpa_supplicant now says:

ioctl[SIOCSIWENCODEEXT]: Invalid argument
Driver did not support SIOCSIWENCODEEXT
WPA: Failed to set GTK to the driver.
RSN: Failed to install GTK
RSN: Failed to configure GTK

Hope this can help me and others.  









