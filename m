Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbXG0KlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbXG0KlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762368AbXG0KlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:41:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:39172 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763923AbXG0KlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:41:12 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, general@lists.openfabrics.org
Subject: [PATCH 0/2] ehca: remove WARNING: externs should be avoided in .c files
Date: Fri, 27 Jul 2007 12:52:49 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271252.50193.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland!
This small patch set fixes some coding-style related issues for ehca:
[1/2] remove checkpatch.pl's warnings "externs should be avoided in .c files"
[2/2] correction include order according kernel coding style
Thanks
Nam

