Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbZHMWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbZHMWbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZHMWbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:31:03 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:59453 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbZHMWbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:31:02 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 18:31:02 EDT
X-Spam-Flag: NO
X-Spam-Score: -0.91
Message-ID: <4A8491E3.4070907@gmail.com>
Date: Fri, 14 Aug 2009 01:21:23 +0300
From: Kari Laine <klaine8@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, klaine8@gmail.com
Subject: I2C -bus programming
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List,

this is my first post here and I am not sure if this is a suitable topic
here. Anyway I have a Velleman K8000 IO-card and it uses I2C over
parallel port to communicate.

when I modprobe i2c-parport it does not complain. I tested without card
connected and it complained so it seems to find the card.

modprobe pcf8591

modprobe i2c-core

modprobe i2c-dev

I am not sure I am doing it right. Should i2c-core probed first ?

anyway now I have

/dev/i2c-0  /dev/i2c-1

Now I don't know whether these i2c-devices refer to this Velleman  board
or some other i2c-device which happen to be in the computer...

If these devices probably refer to Velleman - then how I can refer
different i2c-devices on the board.


I am totally new to this i2c thing (reading spec at the moment but it
does not help much with Linux).

I would be very greatfull if some could point me the way - thanks.

Best Regards
Kari Laine

