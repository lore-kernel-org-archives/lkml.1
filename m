Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbYGYHde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYGYHde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYGYHdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:33:12 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:3628 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYGYHdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:33:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 0/4 REPOST] OF infrastructure for SPI devices
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       jonsmirl@gmail.com
Date: Fri, 25 Jul 2008 03:33:05 -0400
Message-ID: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know what to do with these patches.  I'd really like to see them
in .27, and now that akpm has cleared his queue, the prerequisite patch
has been merged so they are ready to go in.  However, even though there
has been favourable reception on the SPI and linuxppc lists for these
changes I don't have any acks from anybody yet.

David, can you please reply on if you are okay with these patches
getting merged?  If so, do you want me to merge them via my tree, or
do you want to pick them up?

Thanks,
g.

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
