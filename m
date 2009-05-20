Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZETXlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZETXlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZETXlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:41:11 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:41913 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755798AbZETXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:41:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cY4rc06BCQmfWirnOv+F4+Z8rA9p7c1Wotuk5Z2u5ZMDE2GFppHdlYk7kUYzGKB2rpBZ4sqLeKD0+fIrUJ9fTTYGGrB2Ewq3gEe15rYdVRkriD4ylqgeXWG+gu1/EgFQ;
Date: Wed, 20 May 2009 16:40:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20090520164055.68cccabf@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more last minute fix from Rafael for a somewhat obscure (kexec)
related bug.

The following changes since commit
279e677faa775ad16e75c32e1bf4a37f8158bc61: Linus Torvalds (1):
        Merge branch 'fixes-for-linus' of
git://git.monstr.eu/linux-2.6-microblaze

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Rafael J. Wysocki (1):
      PCI PM: Fix initialization and kexec breakage for some devices

 drivers/pci/pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
