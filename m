Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbXITHDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbXITHDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXITHDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:03:10 -0400
Received: from ip213-185-39-113.static.cust.eunet.fi ([213.185.39.113]:40853
	"EHLO dag.newtech.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbXITHDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:03:09 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 03:03:09 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: linux-kernel@vger.kernel.org
Subject: 2.6.22.3 out of memory crash
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 20 Sep 2007 09:56:03 +0300
From: Dag Nygren <dag@newtech.fi>
Message-Id: <20070920065603.CB75310154@dag.newtech.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have the kview zoom function mapped to the scrollwheel
with ctrl.
Now my wife found out and watching our photos wanted
to zoom out a bit. Then she just rotated the scrollwheel a lot
and expected the zoom to happen. What did happen was that
as the there was no apparent response she tried again, and again.

Finally the box probably was out of swap space (2GB RAM) and crashed
miserably.

This is not the expected behavior from a Linux box using a graphics
viewer and I now wonder if there is something I can do about it?
Kernel parameters?
Kview patch?
New wife ;-)

Best
Dag 

