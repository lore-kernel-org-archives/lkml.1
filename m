Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZGCCR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZGCCR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbZGCCRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:17:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:41769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325AbZGCCRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:17:47 -0400
Subject: Reminder for feature Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL
 exports removal date before 2.6.19 Nov 2006
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:33:43 +0530
Message-Id: <1246586623.2530.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arjan,

What:   Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
        (temporary transition config option provided until then)
        The transition config option will also be removed at the same time.
When:   before 2.6.19
Why:    Unused symbols are both increasing the size of the kernel binary
        and are often a sign of "wrong API"
Who:    Arjan van de Ven <arjan@linux.intel.com>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

