Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZLVRdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZLVRdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZLVRdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:33:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57656 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZLVRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:33:30 -0500
Date: Tue, 22 Dec 2009 18:33:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091222173326.GH10314@basil.fritz.box>
References: <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA655.6030205@gmail.com> <4B2FAE7B.9030005@codemonkey.ws> <4B2FB3F1.5080808@gmail.com> <4B300EF8.8010602@codemonkey.ws> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <20091222162110.GG10314@basil.fritz.box> <4B30F375.6050103@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B30F375.6050103@codemonkey.ws>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We're not talking about vaporware.  vhost-net exists.

Is it as fast as the alacrityvm setup then e.g. for network traffic?

Last I heard the first could do wirespeed 10Gbit/s on standard hardware. 
Can vhost-net do the same thing?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
