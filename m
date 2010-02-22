Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0BVRkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:40:32 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:52087 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0BVRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:40:31 -0500
X-Spam-Processed: digidescorp.com, Mon, 22 Feb 2010 11:40:26 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16695eb497=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Zhang Wei <zw@zh-kernel.org>, Li Yang <leoli@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [async_tx-next PATCH 0/2] fsldma: Fix cookie issues
Date: Mon, 22 Feb 2010 11:40:07 -0600
Message-Id: <1266860407-17287-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In modeling a new DMA engine on the FSL code, I ran across what look to be
some bugs in FSL cookie handling. As I don't have FSL HW or even a PPC, 
I can't verify the problem or the fix, but I did ensure that the changes 
compile.

BTW thanks to all involved in creation of the FSL driver, it's a nice model
to follow.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


