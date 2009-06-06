Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZFFHfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZFFHfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZFFHfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:35:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40130 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZFFHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:35:45 -0400
X-Originating-Ip: 216.16.235.2
Date: Sat, 6 Jun 2009 03:35:13 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29.4: /proc/bus/usb is empty
Message-ID: <20090606073513.GA3991@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-4.399, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -2.60)
X-Net-Direct-Inc-MailScanner-From: cdfrey@foursquare.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently upgraded from 2.6.28.9 to 2.6.29.4, and oddly /proc/bus/usb
is now empty.

The devices show up nicely under /dev/bus/usb, but I hadn't noticed
anything indicating that this would be moved.

/proc in general appears to be well populated.

What could cause this?  I can post configs and config diffs if needed,
just let me know.

Thanks,
- Chris

