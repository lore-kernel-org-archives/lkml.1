Return-Path: <linux-kernel-owner+w=401wt.eu-S934479AbXGTPJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479AbXGTPJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933859AbXGTPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:09:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31718 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbXGTPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=reeSo2gN5aJgVqguDgllxkomktpHQ0f31GqIzDueTx3vcy/NeKzM5c29qcuFNQvXJAboJHTibUnsmopbKOcW7xm+oA9qx2HyiTXwA+7Lvpa3ZDECm2NSIhBZD0hBk/sgNTSho1Of7fVXoO0I/oXsX5FW8nF6P5HOCyFCPjTk6MU=
Message-ID: <6bffcb0e0707200809n24ccf6c3v62abbfa50a7d3c41@mail.gmail.com>
Date: Fri, 20 Jul 2007 17:09:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: [broken-out-2007-07-20-00-22] fs/revoked_inode.c warnings
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Your patch fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
introduces new warnings

fs/revoked_inode.c:381: warning: 'revoked_write_begin' defined but not used
fs/revoked_inode.c:388: warning: 'revoked_write_end' defined but not used

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
