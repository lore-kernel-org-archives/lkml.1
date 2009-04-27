Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbZD0VEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbZD0VEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbZD0VE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:04:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48813 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZD0VE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:04:28 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 17:04:28 EDT
X-Originating-Ip: 216.16.235.2
Date: Mon, 27 Apr 2009 16:57:42 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: chrisw@sous-sol.org, linux-kernel@vger.kernel.org
Subject: fs/cifs/connect.c fix missing in latest stable
Message-ID: <20090427205742.GA888@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.8, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: cdfrey@foursquare.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

The latest stable release 2.6.29.2 appears to be missing Jeff Layton's
fix in commit f083def68f84b04fe3f97312498911afce79609e (in Linus's tree).

I'm not the expert... I just noticed that this was mentioned on
full-disclosure: http://marc.info/?l=full-disclosure&m=123936563230145&w=2
(near the end of Andreas's post)

Thanks,
- Chris

