Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYISB4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYISB4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 21:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYISB4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 21:56:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36582 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYISBz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 21:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tydjyNrY3N4cYd1J3ZFCE6t8pAeww5qTarDJjJr4Lvs5yiDf03RiKurG18IcYM/cth
         OWAOW7i8jh8kOxdf21uLISTgTZDavFFhXNes0OAB7BTpiJLw9UhGTYoL1FVU9/irPB2l
         B6qAyXqtytq7Y+e8N1kYdURksRaM70P5uCoQM=
Message-ID: <e38d12ff0809181855n5ca173a9x452540e3dcdc9a9a@mail.gmail.com>
Date: Thu, 18 Sep 2008 21:55:58 -0400
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Some hfsplus questions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some questions about hfsplus:
1) Is there a / how do you patch the fs driver / mount options to
allow starting from an offset (f.e. certain DMG files' HFS+ superblock
start at 32768)?
2) Is there a / how do you patch the fs driver to allow for
transparent zlib decompression of the HFS+ volume (inside the DMG
file)? I lack the kernel skills to reverse-engineer Darwin and create
a kernel patch of a FUSE module.
-- 
Andrey Vul
