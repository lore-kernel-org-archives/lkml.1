Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbZJLPjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbZJLPjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbZJLPjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:39:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54484 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757163AbZJLPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:39:05 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/2] Build fixes for todays next tree
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2009 16:27:17 +0100
Message-ID: <20091012152247.5694.77290.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of networking warns/build fails
---

Alan Cox (2):
      ethoc: fix warning from 32bit build
      libertas: fix build


 drivers/net/ethoc.c                     |    3 ++-
 drivers/net/wireless/libertas/cmdresp.c |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

-- 
How do you raise an elephant ...                     with a crane

