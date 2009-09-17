Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZIQUuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZIQUuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZIQUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:50:06 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33902 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZIQUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:50:05 -0400
X-Greylist: delayed 1781 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 16:50:04 EDT
Date: Thu, 17 Sep 2009 21:20:14 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: rt2x00dev.c:405: error: =?utf-8?Q?too_?=
	=?utf-8?Q?few_arguments_to_function_=E2=80=98rt2x00crypto=5Frx=5Finsert?=
	=?utf-8?B?X2l24oCZ?=
Message-ID: <20090917202014.GA27082@plato.andrewprice.me.uk>
Mail-Followup-To: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
References: <20090917154138.GA31844@sucs.org>
 <20090917172358.GC2577@tuxdriver.com>
 <20090917181133.GA5797@sucs.org>
 <20090917195811.GC2562@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917195811.GC2562@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 03:58:11PM -0400, John W. Linville wrote:
> Oh, I see now -- thanks for the patch!  FWIW, it would seem to only
> show-up when you have CONFIG_RT2500PCI but none of the other rt2x00
> family drivers in your .config...
> 
> John
> 
> P.S.  Could you resubmit to linux-wireless@vger.kernel.org, following
> the normal patch submission guidelines as discussed here?
> 
> 	http://linux.yyz.us/patch-format.html

Done. Just waiting for the greylist to let it through :-)

Cheers,

Andrew
