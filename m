Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXBTQlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXBTQlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030260AbXBTQlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:41:45 -0500
Received: from mail.emacinc.com ([63.245.244.68]:48619 "EHLO mail.emacinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250AbXBTQlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:41:44 -0500
X-Greylist: delayed 2187 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 11:41:44 EST
From: NZG <ngustavson@emacinc.com>
Organization: EMAC.Inc
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Tue, 20 Feb 2007 10:40:32 -0600
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702201040.32355.ngustavson@emacinc.com>
X-SA-Exim-Connect-IP: 63.245.244.67
X-SA-Exim-Mail-From: ngustavson@emacinc.com
Subject: GPIO device class driver
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Relay: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am currently developing support for an ep9xx based SBC and want to export
it's GPIO through sysfs in a simple and standard way,
without adding yet another platform specific gpio driver to the kernel.

As I understand it, a gpio class has already been begun by Robert Schwebel in
but has not as of yet become part of the mainstream kernel.

Searching the archives for this yields no results since 2006.

Can anyone point me to a current patch? 
I'd like to start from there.

thank you,
NZG
