Return-Path: <linux-kernel-owner+w=401wt.eu-S934755AbXGZS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934755AbXGZS4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934299AbXGZSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:55:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:20037 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232AbXGZSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jxFqpSY1yYm5J86O18ZS5adD5BWikDhDzYD0/gsBTqTElQnbdKNywHXbTZ4xj4SlWY/r0/HPFRWIgbbzFFj+ALQAH5OtPch3aYhm3l9QIBncZpVdHp9MhxFztMIVOgZdXRBeF8Uz830P1sY6jssBfhMtg+aUddcP+c4d+ZE6HK0=
Message-ID: <6101e8c40707261155x7d69430bw910eb6be2603764f@mail.gmail.com>
Date: Thu, 26 Jul 2007 20:55:15 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: [GIT PATCH 02/02] change order in Kconfig.cpu (i386)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit c2d2983585e8a46639ca95f6c6122807d8312547
Author: oliver <oliver@pancs.(none)>
Date:   Thu Jul 26 20:42:16 2007 +0200

    change the sort in arch/i386/Kconfig.cpu file, while it is logicaller (by pr
oductions time-line).

    Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

 arch/i386/Kconfig.cpu |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


-- 
Thanks,
Oliver
