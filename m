Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYH1Fiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYH1Fiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 01:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYH1Fim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 01:38:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:10060 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYH1Fim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 01:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=c58gJomkHs72FlDefHkKEJzKbqYnmnJXLzZ9+tJreORFkP7/b/QV306zgV5OjAoN5X
         8Xx9neGMO3oc92eo7mDrsYDhbk8ycwyAR7lPZPVvLmKuquK/FcHYTN9Y2kVsAhan/nK0
         Dsd0n1k66tEm1ywnU5oob0SN7DwCzGKIXFgfA=
Message-ID: <804dabb00808272238s4b74d3cdgcd5fb8686b9e9148@mail.gmail.com>
Date: Thu, 28 Aug 2008 13:38:39 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: some problem with "git pull"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issuing the following:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

result in the following output:

remote: Counting objects: 354, done.
remote: Compressing objects: 100% (220/220), done.
remote: Total 354 (delta 173), reused 278 (delta 134)
Receiving objects: 100% (354/354), 603.00 KiB | 10 KiB/s, done.
Resolving deltas: 100% (173/173), done.
* non-commit: keep
  a72c497614f3fec7453b826b33ab0303c3c087fc of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
* committish: 4c246edd2550304df5b766cc841584b2bb058843
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
fatal: Error in line 1: keep    not-for-merge
a72c497614f3fec7453b826b33ab0303c3c087fc of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

I cannot find anything in the Internet for the above error, anyone can help?

Thank you very much.

-- 
Regards,
Peter Teoh
