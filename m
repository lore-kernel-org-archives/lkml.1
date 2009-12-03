Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZLCCBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZLCCBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZLCCBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:01:22 -0500
Received: from smtp.infotech.no ([82.134.31.41]:60583 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZLCCBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:01:22 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 21:01:21 EST
Message-ID: <4B171A93.2040202@interlog.com>
Date: Thu, 03 Dec 2009 02:55:31 +0100
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matt Taggart <taggart@debian.org>
Subject: [ANNOUNCE] lsscsi-0.23 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format which is one line per device and a "classic"
format (like the output of 'cat /proc/scsi/scsi') are supported.

Version 0.23 is available at
http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm** and deb packages.

ChangeLog:
Version 0.23 2009/12/01 [svn: r76]
   - remove /proc/mounts scan for sysfs mount point, assume
     /sys unless overridden by re-instated '--sysfsroot' option
Version 0.22 2008/12/26 [svn: r71]
...


** The rpm and srpm packages are not currently there but will
    appear in the next day or so. They can be built from the
    lsscsi.spec file in the appropriate environment.

Doug Gilbert
