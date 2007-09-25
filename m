Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbXIYLCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbXIYLCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXIYLCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:02:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:49757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751554AbXIYLCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:02:22 -0400
Cc: akpm@linux-foundation.org, astarikovskiy@suse.de
Content-Type: multipart/mixed; boundary="========GMX189531190718140614822"
Date: Tue, 25 Sep 2007 13:02:20 +0200
From: "Daniel Ritz" <daniel.ritz@gmx.ch>
Message-ID: <20070925110220.189530@gmx.net>
MIME-Version: 1.0
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
To: linux-kernel@vger.kernel.org, Damien Wyart <damien.wyart@free.fr>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>
X-Authenticated: #2813124
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18wh5AOyy4wP1VVN9v2gRv/ks2gyN1Lw/0bFRNNXD
 r1ssdighV9wKggh4eIWMcXh7cdcXE1FHtZXQ== 
X-GMX-UID: 0oeaEk5qbXB+YqGeGDQ2jIwiLyUmZch0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX189531190718140614822
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

does that one help?

[ as attachment since i'm on webmail ]

ACPI: acpi_sleep_prepare() should not depent on CONFIG_SUSPEND
Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

--========GMX189531190718140614822
Content-Type: application/octet-stream; name="acpi-sleep.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="acpi-sleep.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9zbGVlcC9tYWluLmMgYi9kcml2ZXJzL2FjcGkvc2xl
ZXAvbWFpbi5jCmluZGV4IDg1NjMzYzUuLmI5YzZmY2IgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNw
aS9zbGVlcC9tYWluLmMKKysrIGIvZHJpdmVycy9hY3BpL3NsZWVwL21haW4uYwpAQCAtNTksNiAr
NTksNyBAQCBzdGF0aWMgaW50IGFjcGlfcG1fc2V0X3RhcmdldChzdXNwZW5kX3N0YXRlX3QgcG1f
c3RhdGUpCiAJfQogCXJldHVybiBlcnJvcjsKIH0KKyNlbmRpZiAvKiBDT05GSUdfU1VTUEVORCAq
LwogCiBpbnQgYWNwaV9zbGVlcF9wcmVwYXJlKHUzMiBhY3BpX3N0YXRlKQogewpAQCAtODEsNiAr
ODIsNyBAQCBpbnQgYWNwaV9zbGVlcF9wcmVwYXJlKHUzMiBhY3BpX3N0YXRlKQogCXJldHVybiAw
OwogfQogCisjaWZkZWYgQ09ORklHX1NVU1BFTkQKIC8qKgogICoJYWNwaV9wbV9wcmVwYXJlIC0g
RG8gcHJlbGltaW5hcnkgc3VzcGVuZCB3b3JrLgogICoJQHBtX3N0YXRlOiBpZ25vcmVkCg==
--========GMX189531190718140614822--
