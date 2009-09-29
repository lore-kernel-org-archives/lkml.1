Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZI2WNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZI2WNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZI2WNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:13:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZI2WNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=RRe6b9XvfI9xdpcRT7MJVT6qW6F9jm97pLMqpaNs7FMRawbEeWNBKW6LN+DOOZr7+P
         tey4CobKq3bhNiLBer8DUHJAtWVkJIaJ3/Mq03iw8whAd5stMRDvOHyVsyvzpBJj4gGK
         p9FmXb7h/dfFl9e2yVKQw+if0bSTZZLmLn71o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Update_e-mail-for-debugging-via-ohci1394.txt.
Date: Tue, 29 Sep 2009 15:13:57 -0700
Message-Id: <1254262438-31323-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems the address:
ftp://ftp.suse.de/private/bk/firewire/tools/*
is not vary helpful. After a quick search, seems
this was talked about:
http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg02761.html
(can't find the original thread).

Anyways the update address works(although not sure what should happen)
if there is another then I can redu this patch, or something..


 Documentation/debugging-via-ohci1394.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

