Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYGULNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYGULNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYGULN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:13:27 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7981 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGULN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:13:26 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/2] IB/ehca: Two minor circumventions
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Mon, 21 Jul 2008 13:13:23 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807211313.23648.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1/2] fixes spurious PATH_MIG events with certain FW versions
[2/2] inserts a default value for Local CA ACK Delay

Please review these patches and queue them for inclusion into the kernel if
you think they're okay.

Thanks!
  Joachim

