Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYGGVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYGGVKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYGGVKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:10:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53875 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbYGGVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RkFDWTJJEAnRsw9xL/pBozo7PWKzsW8utYYlv3Cdtpwp0j8iCD310Y/KsHUP9XtGtj
         ZDJ83JfdCR76RB4PXwrqOyTGGlDM1RNrIg/NhWTW2Jo+KKRGXLiEUfzFA/aqk9x8Yuad
         0rMrlMZnxrpfFNp70Xhs6OUutsWKcwa0fGjSM=
Message-ID: <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
Date: Mon, 7 Jul 2008 23:10:08 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Cc: rt2400-devel@lists.sourceforge.net,
       "Stefan Bauer" <stefan.bauer@cs.tu-chemnitz.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807072308.57529.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
	 <200807072308.57529.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 11:08 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Check if the arc4 and ecb modules are loaded before loading mac80211 & rt2500pci.
>
> Ivo

Shouldn't we make mac80211 depend on arc4 and ecb?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
