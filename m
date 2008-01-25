Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYAYUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYAYUL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYAYULS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:11:18 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:22932 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYAYULR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:11:17 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/2] IB/ehca: PMA support and a minor fix
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Fri, 25 Jan 2008 21:11:11 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801252111.11915.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset will fix a minor issue and then add support for Performance
MADs, which redirects all PMA queries to the actual PMA QP.

[1/2] adds a missing query_pma_attr()
[2/2] adds PMA redirection code

The patches will apply, in order, on top of Roland's for-2.6.25 branch.
Please review them and apply for 2.6.25 if you think they're okay.

Thanks and regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com



