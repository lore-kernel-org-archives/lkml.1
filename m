Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXESAq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXESAq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 20:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXESAqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 20:46:23 -0400
Received: from onsight-adsl.demon.co.uk ([80.176.235.14]:37141 "EHLO
	jonshouse.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712AbXESAqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 20:46:22 -0400
X-Greylist: delayed 2051 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 20:46:22 EDT
Subject: REQ: .config variable for screen blanker
From: Jonathan Andrews <jon@jonshouse.co.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 19 May 2007 01:12:39 +0100
Message-Id: <1179533559.30563.26.camel@jonspc>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few years ago I posted a feature request for a .config variable to
enable/disable screen blanking in console and frame buffer, I was told
it wasn't a real problem as userspace code was adequate.

Having used linux for a couple of years to build embedded devices im
having another go :-)   It is a real world problem when devices in field
are failing, then going black on the display after 15 mins ....

At the moment if I build a device with a display on it I need to either
run userspace code to set the Ioctl and disable the screen blanker or to
patch the kernel source (as I do currently) 

Having worked with other people it seems to me a lot of us are also
doing this, it would be great if it could be coded into directly into
the kernel.

My code is not the worlds best and to be most useful it would need to be
in 2.4 and 2.6 trees so im grovelling to the kernel maintainers :-D

At a push I can produce the patch, but this is more of a policy
question :-)

Many thanks for considering it.

Cheers,
Jon




