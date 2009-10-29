Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZJ2LNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZJ2LNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZJ2LNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:13:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:64151 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZJ2LNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=jZkVpfEhQSXgMl3Cy2PQSHb87i0pWZuRWXEwFrlutexWr4nXNiAhdEGofj9j+4bE06
         67UdxOhnV2/Y7Q9j2lPeEoaILBk/1IBJDyuzx1c7cIybKGmVKlZOVweqsrZu/TB7XImL
         Zo2sZZlrVEMuZMawegSoU8RUcWFA9U59cRjJE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: davem@davemloft.net
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 12:12:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091028211031.GF2856@tuxdriver.com> <200910282256.00407.bzolnier@gmail.com>
In-Reply-To: <200910282256.00407.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200910291212.41656.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009 22:56:00 Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 28 October 2009 22:10:32 John W. Linville wrote:
> > Dave,
> > 
> > I let my patches pile-up!  Yikes!!
> > 
> > This request includes the usual ton of stuff for -next -- driver
> > updates, fixes for some earlier -next stuff, a few cfg80211 changes to
> > accomodate the libertas driver, etc.  Of note is the rt2800pci support
> > added to the rt2x00 family.
> 
> Unfortunately rt2800pci support is non-functioning at the moment... :(
> 
> > Pleaset let me know if there are problems!
> 
> I find it rather disappointing that all my review comments regarding
> rt2800pci support were just completely ignored and then the initial
> patch was merged just as it was..
> 
> The way rt2800usb and rt2800pci drivers are designed really results
> in making the task of adding working support for RT28x0 and RT30x0
> chipsets to rt2x00 infrastructure more difficult and time consuming
> than it should be... :(

What is even more disappointing (especially after all that "working with"
preaching) is that the patch is now in net-next-2.6..

-- 
Bartlomiej Zolnierkiewicz
