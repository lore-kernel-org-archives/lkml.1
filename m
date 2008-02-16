Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYBPIM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYBPIM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYBPIMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:12:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:58422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYBPIMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from;
        b=jW3UvOXb3MELw6whYXOpEkkLo9wFlXxNfBTZWl5wWwsSnnIidUuzMjq7GNql7zZgglPOZGChdaEPInaWdHyCAcxEw71Wxu36aFzvQYJRmznOtHFY+2WFALFYAOOpSadTzFICkZXRCyPmVebbOTAsmLhTj/zlSIBLmB9bjkib1ok=
Date: Sat, 16 Feb 2008 09:12:39 +0100
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update ide-cd maintainer's email address
Message-ID: <20080216081239.GJ13446@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c65b97fdbb9f3075a37f711aa6b388a48a27d3f4
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Sat Feb 16 09:10:46 2008 +0100

    MAINTAINERS: update ide-cd maintainer's email address
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d2edb4..082d1ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1924,7 +1924,7 @@ S:	Maintained
 
 IDE/ATAPI CDROM DRIVER
 P:	Borislav Petkov
-M:	bbpetkov@yahoo.de
+M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 

-- 
Regards/Gruﬂ,
    Boris.
