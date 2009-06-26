Return-Path: <linux-kernel-owner+w=401wt.eu-S1751062AbZFZGql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbZFZGql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZFZGqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:46:33 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:44453 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZFZGqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=DIN7PeK8S7SitV/o5cpm3O5RRANSsqFu4gmRtQ6jtxQ5r0pluvc4kYUUdoZVDLMcZK
         dFVzf31t/drfB/ndViMVLlJf3hEuSkxDm09IKKWXCoQLVYKjPCyn1Gy6vUH30CwlZ360
         ezqouP6Fl4MrwHta+fZzHPr2hBlVgIrqDFynE=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Fri, 26 Jun 2009 08:46:34 +0200
Message-ID: <cfd18e0f0906252346v53594fb5u2b2bd630b12ded8e@mail.gmail.com>
Subject: MS_I_VERSION added in 2.6.25
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: jean-noel.cordenner@bull.net
Cc: tytso@mit.edu, cmm@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       linux-man <linux-man@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linux 2.6.25 added the MS_I_VERSION flag for inode versioning. Some
text on this should be added to the mount(2) man page. Could someone
of you provide a short description of

* What inode versions are used for
* the MS_I_VERSION flag.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
