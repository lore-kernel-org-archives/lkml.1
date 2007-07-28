Return-Path: <linux-kernel-owner+w=401wt.eu-S937564AbXG1IIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937564AbXG1IIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 04:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765496AbXG1IIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 04:08:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:8414 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765460AbXG1IIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 04:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pOQ6KCUXwkveIb8oRVOg6rIxjSHAmaiX7JPpGe49vRWaLkNZ7pQnBKuLRA6HQN1zPdR+VEBHJGKy8YoeNUKBIU3SISP4nGRH2QNwfHhTwDkW2LzgWUHS/0ubbFcgPsdwFTcUeACiiUrzG8bURUMFcyRzYVSKG/akAQChewY5f6E=
Message-ID: <e1d5030b0707280108v236cc522m454c58e1044f1996@mail.gmail.com>
Date: Sat, 28 Jul 2007 13:38:01 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-mtd@lists.infradead.org
Subject: Testing of CPRM on SD Card
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

    Our product development requires that we use the CPRM security
feature of SD card for protecting our material. I have been searching
the web for a SD host controller / Software which is CPRM capable, so
that we can write/read an encrypted SD card with the testing keys
provided by the 4C Entity) and test our prototype. But I could find
none. There are IP cores but no manufactured chips.

   Has anybody of you done similar stuff ? How do I go about testing
the CPRM feature of the SD card on our prototype ?

Thanks,
Midhun.
