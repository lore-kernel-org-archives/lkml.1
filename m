Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZHJRax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZHJRax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZHJRax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:30:53 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:46638 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754990AbZHJRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:30:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gjVtfT2CHTnd6IS+npla8Xr4kaSt7LPi8cTFZllkcdGouoAr2rVLzl93tZm8SI6v2qFxKbVY+ya+cEhD1+X0QgHStivHDUzUlwQGaA9zfTXmYlkA+tx23iyKPpxGxckZ;
Date: Mon, 10 Aug 2009 10:30:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20090810103051.30ba057f@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
90bc1a658a53f8832ee799685703977a450e5af9: Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just a couple of fixes for ia64 related breakages that crept in this
time around.

Kenji Kaneshige (2):
      PCI hotplug: SGI hotplug: fix build failure
      PCI hotplug: SGI hotplug: do not use hotplug_slot_attr

 drivers/pci/hotplug/sgi_hotplug.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
