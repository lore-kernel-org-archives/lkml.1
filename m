Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbXGOGni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbXGOGni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 02:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXGOGna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 02:43:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2944 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbXGOGna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 02:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=hkOpaMX1sVMP+WZ/QS09kAxpTYgqmSc1RFSgAKn7j8Nrg9b+YCe6XeXqspLJK3nA08kR815fCHFSqEMxVPqbRgA8Pi9obC1nQ5/8L1J/MW2VcBy8dhqWIM2kC+yOdLC8hNP5wKszTe+MOCOvMCOwmRtGAanaz///Wx2ocbyOjtc=
Date: Sun, 15 Jul 2007 16:43:23 +1000
From: Andrew Hendry <andrew.hendry@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, jejb@steeleye.com
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] re: x86 setup code rewrite in C - revised
Message-ID: <20070715164323.78cf8db1@jed>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I tested the 'x86 setup code rewrite revised' patches on a few new
Pentium systems and some virtualized environments without any issues.

Here are some further patches ontop of yours to remove some unused
code and ifdef the MCA setup. 

-Andrew
