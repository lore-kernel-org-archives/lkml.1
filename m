Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZJPJPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZJPJPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZJPJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:15:43 -0400
Received: from bamako.nerim.net ([62.4.17.28]:57737 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZJPJPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:15:43 -0400
Date: Fri, 16 Oct 2009 11:15:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
   DP55KG motherboard? (chip ID: 0xb473)
Message-ID: <20091016111504.5d9cb0ba@hyperion.delvare>
In-Reply-To: <alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan>
	<alpine.DEB.2.00.0910140403150.15961@p34.internal.lan>
	<alpine.DEB.2.00.0910140856190.19307@p34.internal.lan>
	<20091015100557.22243433@hyperion.delvare>
	<alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 04:30:29 -0400 (EDT), Justin Piszcz wrote:
> A picture of it is available here:
> http://img.hexus.net/v2/cpu/intel/LGA1156/IMG_0831-big.jpg
> Another:
> http://www.overclockersclub.com/vimages/intel_corei5750_corei7870/20.jpg
> Another:
> http://www.hitechlegion.com/images/stories/ici7_870/11.jpg
> A close up of the chip itself!
> http://www.motherboards.org/imageview.html?i=/images/reviews/motherboards/1948_p3_13.jpg
> 
> Is this the chip to which you are referring?
> 
> Winbond
> W83677HG-i
> 919S9BE918B001FB
> 919S9BE918B001FB*typed twice to confirm (same #s on two different 
> board/reviews)
> 
> Is there anything else needed?

Please give a try to the latest version of sensors-detect:

http://dl.lm-sensors.org/lm-sensors/files/sensors-detect

It should find your chip now. Next step is to actually add support for
it, but it will take more time and efforts.

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
