Return-Path: <linux-kernel-owner+w=401wt.eu-S939061AbXHIMZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939061AbXHIMZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbXHIMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:25:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:45291 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbXHIMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tbC0eh0UUtcGp6G5T5LaQwQvkJJBvZ9H+hqvSH5YZj5wUb5uMovtGnLR3/juFrbnqoQajhThvEg7foSm3l/Q9ZToOxiDXtUKq3BqOeOdLwdwTIVcPDK42weSYyzx/j8UJqZmwUZFJzCKQH5Be6rnx5EdOxEQ+UuGLtQYpMHxK48=
Message-ID: <e1d5030b0708090525m355cead1hd9342d1e6726c994@mail.gmail.com>
Date: Thu, 9 Aug 2007 17:55:32 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question regarding ADS7846 Touchscreen controller
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

    We are running vanilla 2.6.22 linux kernel in i.MX 21 lite kit,
patched for our board and utilizing the generic touchscreen driver
drivers/input/touchscreen/ads7846.c for our touch screen. We have
changed the register values in spi_imx.c for i.MX21. The code seems to
run but we are not getting correct values for the touchscreen
positions. The SPI registers always return a value of 4096. We have
checked for correct clock. But still it does not help.

   Has anybody faced a similar problem before?

Thanks,
Midhun.
