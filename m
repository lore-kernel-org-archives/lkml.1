Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZBLTLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZBLTLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZBLTLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:11:37 -0500
Received: from mx1.aecom.yu.edu ([129.98.1.51]:41298 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZBLTLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:11:37 -0500
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Feb 2009 14:11:37 EST
X-AuditID: 816201a0-a8de3bb000001567-b1-49946db00f71
Mime-Version: 1.0
Message-Id: <a0624046bc5b8a6a6249d@[129.98.90.227]>
Date: Thu, 12 Feb 2009 13:40:58 -0500
To: Eric.Moore@lsi.com
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: [Q] What's the story with MPT Fusion driver versioning?
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LSI website distributes three MPT Fusion driver packages on its 
website, each with a different version number, 2.06.77.00, 
3.13.04.00, and 4.00.43.00. They seem to be tied to specific RedHat 
and SUSE releases and clearly one of them had been built for an 
earlier kernel.

However, the numbering is wholly out of step with the version in the 
mainline kernel, which is presently 3.04.07. By that measure, 
one--even LSI tech support--might think it is grossly outdated, but, 
in fact, the website packages are dated 8/20/08, which suggests the 
opposite.

On top of that, LSI's tech support insists that the driver in the 
mainline kernel isn't "certified," and, therefore, they can't support 
it, which doesn't seem to make much sense.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
