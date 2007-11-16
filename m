Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbXKPTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbXKPTtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbXKPTtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:49:12 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:61101 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbXKPTtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:49:12 -0500
Date: Fri, 16 Nov 2007 20:45:28 +0100
Message-Id: <2089856624@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: =?iso-8859-15?Q?distro_specific_kernels_vs_vanilla_kernel_and_how_to_c?=
 =?iso-8859-15?Q?ompare_among_each_other?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/LwaMXcvrlOPorV0yc+PAekk/xNBTzyBwx/5vc67IMWbt/L
 mVvVKpJw6BzgSc/T8op8YV7pxkSlyUpboOw5jK3Io9krOohXfI=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

does somebody know if there is a website or a project for giving comfortable and deeper insight into what`s specific to distro`s kernels and what`s their difference to vanilla kernel ?

i mean some way to have some transparancy to what different distro vendors add to vanilla kernel sources and thus turning it into their own specific version. 

some simple version of this could be a simple browseable archive like this:

Fedora8-Kernel-2.6.23.1-42.fc8/vanilla:
insgesamt 44492
drwxr-xr-x 2 root root     4096 16. Nov 20:24 .
drwxr-xr-x 4 root root    12288 16. Nov 20:24 ..
-rw-r--r-- 1 root root 45488158 10. Okt 00:50 linux-2.6.23.tar.bz2
-rw-r--r-- 1 root root     1412 12. Okt 20:58 patch-2.6.23.1.bz2

Fedora8-Kernel-2.6.23.1-42.fc8/patches:
insgesamt 10688
drwxr-xr-x 2 root root   12288 16. Nov 20:24 .
drwxr-xr-x 4 root root   12288 16. Nov 20:24 ..
-rw-r--r-- 1 root root   18908  3. Aug 01:37 linux-2.6-devmem.patch
-rw-r--r-- 1 root root     461 12. Sep 20:35 linux-2.6-drivers-ssb-debug-revision.patch
-rw-r--r-- 1 root root     839 16. Okt 02:15 linux-2.6-drm-fix-i915-allocation.patch
-rw-r--r-- 1 root root    1235 22. Okt 22:49 linux-2.6-e1000-bad-csum-allow.patch
-rw-r--r-- 1 root root   52318 22. Sep 13:45 linux-2.6-execshield.patch
-rw-r--r-- 1 root root    4361  9. Okt 07:18 linux-2.6-firewire-lockdep.patch
....lot`s of patches

OpenSuSE_10.3-Kernel-2.6.22.5-31/vanilla:
insgesamt 44120
drwxr-xr-x 2 root root     4096 16. Nov 20:02 .
drwxr-xr-x 4 root root     4096 16. Nov 20:02 ..
-rw-r--r-- 1 root root 45119878 22. Sep 16:23 linux-2.6.22.tar.bz2

OpenSuSE_10.3-Kernel-2.6.22.5-31/patches:
insgesamt 10360
drwxr-xr-x 15 root root   4096 16. Nov 20:07 .
drwxr-xr-x  4 root root   4096 16. Nov 20:02 ..
drwxr-xr-x  2 root root   4096 16. Nov 20:04 patches.apparmor
drwxr-xr-x  2 root root  12288 16. Nov 20:04 patches.arch
drwxr-xr-x  2 root root  12288 16. Nov 20:04 patches.drivers
drwxr-xr-x  2 root root   4096 16. Nov 20:05 patches.fixes
drwxr-xr-x  2 root root   4096 16. Nov 20:05 patches.kernel.org
-rw-r--r--  1 root root 104687 22. Sep 16:23 supported.conf
.....even more patches


if something like this doesn`t already exist - would it be useful to start such a project ?

regards
roland
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

