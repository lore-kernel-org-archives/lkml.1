Return-Path: <linux-kernel-owner+w=401wt.eu-S1765217AbYAaIiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765217AbYAaIiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYAaIiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:38:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:48803 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbYAaIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LOa+wFPjizSnDK/+EAdnRr37s5BCrAeh9EnLSJ4AUozXINZ/W3T75Q7dZKxn87Eja4veb/9BVuFK6wM+XzKhxow9BakSi0K9A8PvoHOHmDRs4ooSlVQyCnShRn8F4INqRmVB5+gW3VI/OmqenAA3ll5SrfXrZDF1PtObw95Jqv8=
Message-ID: <38b2ab8a0801310038o2906ab68ta8893240576d806d@mail.gmail.com>
Date: Thu, 31 Jan 2008 09:38:10 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [Kbuild] How to clean a particular directory ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to clean a particular directory in the kernel tree.

I tried several things such as:

$ make drivers/char clean
$ make -f scripts/Makefile.clean obj=drivers/char

But it doesn't work.

Could anybody give me  a hint ?

Thanks
-- 
Francis
