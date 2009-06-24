Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbZFXRPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbZFXRPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZFXRPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:15:05 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:33826 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZFXRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:15:04 -0400
Message-ID: <4A425DD9.1080007@csr.com>
Date: Wed, 24 Jun 2009 18:09:45 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UWB fixes for 2.6.31
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2009 17:09:46.0000 (UTC) FILETIME=[92DB2900:01C9F4EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull two small bug fixes for the UWB system.

The following changes since commit 3218911f839b6c85acbf872ad264ea69aa4d89ad:
  Linus Torvalds (1):
        Merge git://git.infradead.org/~dwmw2/mtd-2.6.30

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

Frank Leipold (1):
      uwb: allow WLP to be used with IPv6.

Roel Kluin (1):
      uwb: event_size should be signed

 drivers/uwb/hwa-rc.c   |    2 +-
 drivers/uwb/wlp/txrx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
