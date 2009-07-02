Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbZGBQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbZGBQsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZGBQsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:48:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:58790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZGBQsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:48:16 -0400
Message-Id: <D77CBB49-A340-4282-9ACF-2172D1BB9E43@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: good example of a tty driver
Date: Thu, 2 Jul 2009 11:48:09 -0500
Cc: Linux-Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Can you point me at any good drivers to use as an example of using the  
tty layer.  I'm trying to get an out of tree driver brought up to date  
for the Avocent ESP-16 MI Serial Hubs (serial over ethernet):

http://www.connectivity.avocent.com/products/network-based/esp_16.asp

Thankfully the have a GPL driver but it was last updated against 2.6.23:

http://www.connectivity.avocent.com/drivers/esp_serial_hubs/dd64e069.asp

However I've never worked on any tty drivers so its a bit black magic  
at this point.  I was hoping that an example would at least get me  
able to bring the driver up to a point that we can get it into the  
staging tree.

thanks

- k
