Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYHDNZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYHDNZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYHDNZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:25:35 -0400
Received: from barnes.cubic.ch ([78.46.44.112]:57374 "EHLO barnes.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbYHDNZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:25:33 -0400
X-Greylist: delayed 3520 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 09:25:33 EDT
Message-ID: <4896F56D.7080503@cubic.ch>
Date: Mon, 04 Aug 2008 14:26:21 +0200
From: Tim Tassonis <timtas@cubic.ch>
Reply-To: timtas@cubic.ch
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: reiser4 for 2.6.27-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "barnes.cubic.ch", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  > Why is reiser4 still not in a vanilla kernel for testing.
	I have had > to apply the reiser4 patches from -mm kernels to vanilla based
	> patchset for over a year now. Reiser4 works fine, what will it take to
	> get it included in vanilla? Here is a patch to add reiser4 to > 2.6.27-rc1:
	> > http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch > > -Ryan [...]
	Content analysis details:   (-2.9 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0067]
	1.5 DNS_FROM_RFC_BOGUSMX   RBL: Envelope sender in bogusmx.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is reiser4 still not in a vanilla kernel for testing. I have had
> to apply the reiser4 patches from -mm kernels to vanilla based
> patchset for over a year now. Reiser4 works fine, what will it take to
> get it included in vanilla? Here is a patch to add reiser4 to
> 2.6.27-rc1:
> 
> http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
> 
> -Ryan

A good thing for a start would be to rename the whole thing to something 
else, for obvious reasons.

Tim
