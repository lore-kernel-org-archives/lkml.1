Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbXJDENo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbXJDENo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXJDENf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:13:35 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10384 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXJDENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:13:34 -0400
Date: Wed, 03 Oct 2007 22:13:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/3] Fixups to SystemACE driver
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-id: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Here are some more Sysace patches based on comments received on the
first series and a run through sparse.  Can you please queue them up
for 2.6.24?

Thanks,
g.

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
