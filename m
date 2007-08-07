Return-Path: <linux-kernel-owner+w=401wt.eu-S1761202AbXHGHYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761202AbXHGHYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbXHGHW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:22:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:50278 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384AbXHGHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JeBj3qVQRmmLeAs8XIRqdZCKXYn3bwedCF/kSrv56EPplFshmLpyXnk7wokHyyZ14TN1bFzFlJyK7UenZFgXrInSWFnxphztpYGg0EqJ1K2TaNUJD1qxBJhHIzvQng85qRboTgKv+X8/20jeICoCLgBY//P+FgQTEH760Ufa/mA=
Message-ID: <6bffcb0e0708070022q5614fe55u98d38135065cd238@mail.gmail.com>
Date: Tue, 7 Aug 2007 09:22:25 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: O(1) vs. CFS interbench comparison
Cc: "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If someone is interested, here are the results of O(1) and CFS
interbench comparison
http://www.stardust.webpages.pl/files/data/o1_vs_cfs/o1_vs_cfs.html

http://www.stardust.webpages.pl/files/data/o1_vs_cfs/cfs_interbench
http://www.stardust.webpages.pl/files/data/o1_vs_cfs/o1_interbench

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
