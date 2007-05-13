Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXEMRXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXEMRXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXEMRXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:23:08 -0400
Received: from cv3.cv.nrao.edu ([192.33.115.2]:57428 "EHLO cv3.cv.nrao.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbXEMRXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:23:07 -0400
X-Greylist: delayed 648 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 13:23:07 EDT
Message-ID: <464746EC.10608@nrao.edu>
Date: Sun, 13 May 2007 13:12:12 -0400
From: Rodrigo Amestica <ramestic@nrao.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: is linux still a none swappable kernel?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MailScanner-Information: Please contact postmaster@cv.nrao.edu for more information
X-MailScanner: Found to be clean
X-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-101.44,
	required 5, autolearn=disabled, ALL_TRUSTED -1.44,
	USER_IN_WHITELIST -100.00)
X-MailScanner-From: ramestic@nrao.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In some older posts I have read that memory allocations via kmalloc
and vmalloc are not swappable, that is, these memory chunks are not
paged out to swap area. Is this still the case with linux kernel 2.6?

thanks,

