Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZELJny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZELJny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759097AbZELJmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:42:55 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40520 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZELJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:42:50 -0400
X-Auth-Info: i8MAyR+0e7MaolCZKGeWS1DsYHK4/+0PIjeLpjIO47Y=
Message-Id: <20090512094248.439786706@denx.de>
User-Agent: quilt/0.47-1
Date: Tue, 12 May 2009 11:42:48 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] iproute2: Support for CAN network devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here are the patches for the "ip" program of the iproute2 utility
suite adding support for CAN netlinks.

  1/2) iproute2: Fixes an issue with cross-compilation
  2/2) iproute2: Support for the CAN netlink

The first patch is required to get it cross-compiled.

The patches are based on v2 of the patch series for the Linux kernel
with the subject:

  [PATCH v2 0/7] can: CAN network device driver interface and drivers

posted a few minutes ago:

  http://marc.info/?l=linux-netdev&m=124212048701347&w=2

Please consider these patches for inclusion when the Linux kernel
patches have been accepted.

Thanks,

Wolfgang.

