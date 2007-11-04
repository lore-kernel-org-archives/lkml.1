Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXKDPH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXKDPH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXKDPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:07:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:65345 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbXKDPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dT/F211M00xI9IrOzplfzDt8Z5c9vushpvpRYJX6NVivaiJc6ONL72ScL7aReCH39pxg2GPsy/ylb2e3Ha5A0Rjk2szNMyLLYMYusH1kwG7A6oxwaGYL7khI3oMAPM//FkNK9vEJOmSkeZY4MFu1Sm+SKVDN5a3Rm5IgDU8qUxg=
Message-ID: <e5bfff550711040707q2659ca2at7ba274fc2ab03d38@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:07:48 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Remove duplicated include
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes some duplicated #include found by a script.

The whole tree has been checked but 'arch' and 'drivers' directories.

In case someone is interested I can provide patches also for the
missing directories

Marco
