Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYJQBmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYJQBmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYJQBlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:41:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:58726 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYJQBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=m2bZm2G4YXHl1yYpPOiz3yZih8H+dal2a0Ic9mPQ98cz2bCFGhmm7CF3IHyiYtBi07
         9FsXcIp7JzvwYdyV885CqPlVgxWveblWeE3YdVsocd5asftp8kVu2j7GPGZr3gS7gNxk
         AOf6aVFYAQ60frrFIuk9Vg8FtgkY+dWR8kiMY=
Date: Fri, 17 Oct 2008 05:44:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] .gitignore update
Message-ID: <20081017014452.GA13453@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Documentation/accounting/.gitignore   |    1 +
 Documentation/auxdisplay/.gitignore   |    1 +
 Documentation/connector/.gitignore    |    1 +
 Documentation/ia64/.gitignore         |    1 +
 Documentation/networking/.gitignore   |    1 +
 Documentation/pcmcia/.gitignore       |    1 +
 Documentation/spi/.gitignore          |    2 ++
 Documentation/video4linux/.gitignore  |    1 +
 Documentation/vm/.gitignore           |    1 +
 Documentation/watchdog/src/.gitignore |    2 ++
 arch/x86/boot/compressed/.gitignore   |    2 ++
 arch/x86/kernel/cpu/.gitignore        |    1 +
 12 files changed, 15 insertions(+)

new file mode 100644
--- /dev/null
+++ b/Documentation/accounting/.gitignore
@@ -0,0 +1 @@
+getdelays
new file mode 100644
--- /dev/null
+++ b/Documentation/auxdisplay/.gitignore
@@ -0,0 +1 @@
+cfag12864b-example
new file mode 100644
--- /dev/null
+++ b/Documentation/connector/.gitignore
@@ -0,0 +1 @@
+ucon
new file mode 100644
--- /dev/null
+++ b/Documentation/ia64/.gitignore
@@ -0,0 +1 @@
+aliasing-test
new file mode 100644
--- /dev/null
+++ b/Documentation/networking/.gitignore
@@ -0,0 +1 @@
+ifenslave
new file mode 100644
--- /dev/null
+++ b/Documentation/pcmcia/.gitignore
@@ -0,0 +1 @@
+crc32hash
new file mode 100644
--- /dev/null
+++ b/Documentation/spi/.gitignore
@@ -0,0 +1,2 @@
+spidev_fdx
+spidev_test
new file mode 100644
--- /dev/null
+++ b/Documentation/video4linux/.gitignore
@@ -0,0 +1 @@
+v4lgrab
new file mode 100644
--- /dev/null
+++ b/Documentation/vm/.gitignore
@@ -0,0 +1 @@
+slabinfo
new file mode 100644
--- /dev/null
+++ b/Documentation/watchdog/src/.gitignore
@@ -0,0 +1,2 @@
+watchdog-simple
+watchdog-test
--- a/arch/x86/boot/compressed/.gitignore
+++ b/arch/x86/boot/compressed/.gitignore
@@ -1 +1,3 @@
 relocs
+vmlinux.bin.all
+vmlinux.relocs
new file mode 100644
--- /dev/null
+++ b/arch/x86/kernel/cpu/.gitignore
@@ -0,0 +1 @@
+capflags.c
