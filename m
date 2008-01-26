Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYAZW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYAZW3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYAZW3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:29:35 -0500
Received: from clarity.mcc.ac.uk ([130.88.200.144]:59496 "EHLO
	clarity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYAZW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:29:34 -0500
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2008 17:29:34 EST
Message-ID: <479BAEE9.1090801@gentoo.org>
Date: Sat, 26 Jan 2008 22:06:33 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux kernel list <linux-kernel@vger.kernel.org>, andreas.eckstein@gmx.net,
       matthew@wil.cx
Subject: Incorrect authorship for pci-disable-decoding-during-sizing-of-bars.patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Nothing major, but the From: line in your -mm patch 
pci-disable-decoding-during-sizing-of-bars.patch is wrong.

The patch is from Matthew Wilcox <matthew@wil.cx>, just Andreas helped 
bring the issue to people's attention :)

Thanks,
Daniel
