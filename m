Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZLRO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZLRO2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZLRO2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:28:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53939 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZLRO2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:28:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JZsDFavkk/YhMuUfLNNhgcouRvm65KO7cmcUCeBk7PCIH/RYHsyCFiyM0uKvBOK6Bv
         PlMBE/n4ZS39VXiggAWT5hlRivZyLSOD4Wn8BNKPGcnrmbgedk1NS6iwF5rEMveSuKIy
         z5t0NiuXGz/OeN0Lj/D60D+DY3fUv9lN+H8kU=
Message-ID: <4B2B9179.5000009@gmail.com>
Date: Fri, 18 Dec 2009 14:28:09 +0000
From: Lukasz Sokol <el.es.cr@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Lukasz Sokol <el.es.cr@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Rfkill buttons : bi-stable, mono-stable, tactile
References: <loom.20091217T122606-341@post.gmane.org> <20091217150709.GA6375@srcf.ucam.org> <loom.20091217T161042-883@post.gmane.org> <20091217195231.GA11747@srcf.ucam.org> <4B2B42B6.1010501@gmail.com> <20091218141543.GA24825@srcf.ucam.org>
In-Reply-To: <20091218141543.GA24825@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Dec 18, 2009 at 08:52:06AM +0000, Lukasz Sokol wrote:
> 
>> lrwxrwxrwx 1 root root 0 2009-12-17 20:30 rfkill0 -> ../../devices/pci0000:00/0000:00:1c.2/0000:03:00.0/ieee80211/phy0/rfkill0
> 
> Ok. You have no platform rfkill interface. ath5k needs to notice that 
> it's been killed and update its rfkill state accordingly.
> 
So it is up to the ath5k driver developers then ? :)

Lukasz
