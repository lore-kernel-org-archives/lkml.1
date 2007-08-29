Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbXH2Usg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbXH2Usg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 16:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXH2Us1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 16:48:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:25306 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbXH2Us0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 16:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Bp7jQNa4cQr+q4wxAsvizFNVtPDT9F+zZBRqqZpMJq4pbgByf0JC11BRndudsDF4Im6iBz5XfTkTytDU0/vDhOBqveSFAiUa+YE/UnSrsBXyV8hny8KWkT7kIREIiUZmz1VPlINAjV718498CFg7+MnkW3Mpr06vytmdcVoCKHc=
Message-ID: <ab40e9c0708291348u3c4ee095r20cd20dd090c23aa@mail.gmail.com>
Date: Wed, 29 Aug 2007 22:48:24 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: from which address does the kernel load initrd?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

does anyone know from which address does the kernel load the initrd? I
mean the default value?

I want to boot the filesystem using a ramdisk. but the I don't know
where to put it in my ram? as I don't have flash , I can only load the
ramdisk into the ram.

and which boot option should I use?

thanks

regards,

yang
