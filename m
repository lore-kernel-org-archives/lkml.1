Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXFSOre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXFSOre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXFSOr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:47:27 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:47891 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbXFSOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:47:25 -0400
Date: Tue, 19 Jun 2007 16:48:46 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Message-ID: <20070619144845.GJ4374@enneenne.com>
References: <5d5443650706190428q341a50a1obae68b2565d0ed7@mail.gmail.com> <20070619121020.GA8902@enneenne.com> <20070619153940.0e120fb0@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619153940.0e120fb0@hyperion.delvare>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [i2c] [PATCH] I2C: TSL2550 support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:39:40PM +0200, Jean Delvare wrote:
> Hi Rodolfo,
> 
> On Tue, 19 Jun 2007 14:10:20 +0200, Rodolfo Giometti wrote:
> > Add support for Taos TSL2550 ambient light sensors.
> > (http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).
> > 
> > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> 
> Did you ever read my review of your driver?
> http://lists.lm-sensors.org/pipermail/i2c/2007-February/000824.html

Please, note that I left LUX calculation untouched since on my data
sheet I have only such cumputation example. :(

Hope it could be ok anyway...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
