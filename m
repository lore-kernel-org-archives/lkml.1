Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYDUIDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYDUIDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYDUIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:03:15 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:15563 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYDUIDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:03:13 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/5] IB/ehca: IB compliance fix, tracing verbosity and module parameters
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Mon, 21 Apr 2008 09:03:10 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804211003.10695.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1/5] makes the driver reject SQ WRs if the QP is not in RTS
[2/5] bumps a lot of tracing into higher debug_levels
[3/5] removes the mr_largepage parameter
[4/5] changes some bool-ish module parms into actual bools,
      also updates some descriptions
[5/5] bumps the version number to 0026

Please review these patches and queue them for inclusion into 2.6.26 if you
think they're okay.

Thanks!
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com




