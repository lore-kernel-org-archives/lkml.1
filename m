Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193Ab0A0XLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0A0XLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085Ab0A0XLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:11:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34756 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0A0XLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:11:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2] PM / Runtime: Clean-up and documentation
Date: Thu, 28 Jan 2010 00:09:44 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001280009.44589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches are on top of the linux-next branch of my suspend-2.6
tree:

[1/2] - Clean up pm_runtime_disable()

[2/2] - Document new runtime PM helper functions as appropriate.

Thanks,
Rafael

