Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYIDUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYIDUWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYIDUW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:22:27 -0400
Received: from mail.work.de ([212.12.32.20]:34050 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbYIDUW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:22:26 -0400
Message-ID: <48C0437C.9050107@gmail.com>
Date: Fri, 05 Sep 2008 00:22:20 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: linux-dvb@linuxtv.org
Subject: DVB Update [PATCH 0/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds newer delivery systems, modulations and parameters.

It adds a much needed uplift for DVB for adding newer delivery systems
such as DVB-S2, DVB-H. Also it allows the addition of future modulations
in an easier manner. Newer delivery systems such as DMB-T/H and ISDB-T/H
can easily be added later on, without breaking compatibility.

The initial post for the update:
http://article.gmane.org/gmane.linux.drivers.dvb/25606

More details are available according to the discussions:
http://article.gmane.org/gmane.linux.drivers.dvb/25608
http://article.gmane.org/gmane.linux.drivers.dvb/25610
http://article.gmane.org/gmane.linux.drivers.dvb/25611

which were reworked again according to
Code Review from Johannes Stezenbach <js@linuxtv.org>. (The rework
happened just immediate after a pull request and a merge):

http://article.gmane.org/gmane.linux.drivers.dvb/25616

It was reworked again,
Code Review from Oliver Endriss <o.endriss@gmx.de>,
reviewed again and relevant changes applied:

http://article.gmane.org/gmane.linux.drivers.dvb/37406

The resulting changes were also tested. Drivers also available at
http://jusst.de/hg/multiproto
Some newer drivers also on the way.


The DVB API update patches are available also at:
http://www.kernel.org/pub/linux/kernel/people/manu/dvb_patches/

Sample applications:
simple zapping app
http://linuxtv.org/hg/dvb-apps/file/ef0bf9bd3bd4/test/szap2.c

VDR 1.7.0 ftp://ftp.cadsoft.de/vdr/Developer/vdr-1.7.0.tar.bz2

Regards,
Manu


