Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbXFILfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbXFILfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXFILfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:35:46 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:40158 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752827AbXFILfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:35:45 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-kernel@vger.kernel.org
Subject: drivers/char/mwave/3780i.c doesn't compile with gcc 4.2.0
Date: Sat, 9 Jun 2007 14:35:30 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091435.30737.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting the following error :

drivers/char/mwave/3780i.c: In function 'dsp3780I_EnableDSP':
drivers/char/mwave/3780i.c:323: error: cannot take address of 
bit-field 'LoadValue'
drivers/char/mwave/3780i.c:323: error: cannot take address of 
bit-field 'LoadValue'
drivers/char/mwave/3780i.c:323: error: cannot take address of 
bit-field 'LoadValue'

Regards,
ismail

-- 
Perfect is the enemy of good
