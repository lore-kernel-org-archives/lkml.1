Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbZCaNaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbZCaNaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbZCaN3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:29:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:19084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbZCaN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t4ZzIrWN+SUPGnQFuG0O61VKWWqEoP6l5dO4G419y2bNbWEJhMQutmewYUjXYmlm6B
         n6MqRfUXYsESlKQXADjBTIVdU5ct3aQK/JVy9QnZmul5VnG/nuKe2AsoM0rV2kHHgYEG
         l6UMA3liftqYLighg6zViMzx6cDvv1Yk5IZgE=
Date: Tue, 31 Mar 2009 09:29:44 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, roel.kluin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Add hvc_console to MAINTAINERS
Message-ID: <20090331132944.GB2332@yoda.jdub.homelinux.org>
References: <49BF956B.9030109@gmail.com> <20090330133531.f5d99c09.akpm@linux-foundation.org> <20090330205553.GA19278@yoda.jdub.homelinux.org> <20090330141852.59baaeda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330141852.59baaeda.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS entry for the hypervisor virtual console support
used on IBM POWER servers.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
---

diff --git a/MAINTAINERS b/MAINTAINERS
index c5f4e9d..387ad45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2176,6 +2176,11 @@ W:       http://www.ia64-linux.org/
 T:     git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:     Maintained
 
+IBM HYPERVISOR VIRTUAL CONSOLE
+P:     Several
+L:     linuxppc-dev@ozlabs.org
+S:     Maintained
+
 IBM MCA SCSI SUBSYSTEM DRIVER
 P:     Michael Lang
 M:     langa2@kph.uni-mainz.de

