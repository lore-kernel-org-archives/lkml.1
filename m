Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYKBMaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYKBMaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 07:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYKBM3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 07:29:53 -0500
Received: from vsmtp4.tin.it ([212.216.176.224]:64492 "EHLO vsmtp4.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYKBM3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 07:29:53 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Nov 2008 07:29:52 EST
Date: Sun, 2 Nov 2008 13:24:42 +0100
From: The Peach <smartart@tiscali.it>
To: LKML <linux-kernel@vger.kernel.org>
Subject: kuroboxHG.dts compile FATAL ERROR on 2.6.26
Message-ID: <20081102132442.77e3bf93@tiscali.it>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAABtQTFRFAAAACwsLMDAwT09PcXFxj4+PsLCw0dHR9/f3R+HqpwAAAAF0Uk5TAEDm2GYAAAINSURBVDjLzZRJd6JAFIU5Cva6CEiWDeKwZBDjkslhKQaUpYISlnEKrCPK+9ldpNVodN/9VnXuV6du1X3vFEH8J0Vq1mNgO/pDnTrUG9rDk2qxMnugV3QXVu/eA2K2IFOle91dpwAicXcYtWMBIAhHdxZiF4OMu9NH8wQflTcWd9b1XW+7cYzfPx+xFRTDsQRB//F6iq8JilozxvStOzXg1w2WUVZTmrolBreKnqtO1g1qN3o/SHf5cJDhe3HbaxBwcC6zcaV75PACPmdXJmUFK/nStnsxHOnvuCiiCUcT0YKAkBi3K995CH5I96OlF6W5y8vW+xl0xo645BEuWowhbF6aUkadENkF4CxzCMLZZFR+2df3G7wfph4EfpCdyNgEFgrwBHkHd/FTPFn/qkIH9tsuQm9JCzbVjFv+Tbz9kq7hMC28t8P8KU3ok/tc9rMuNB2EmgHMWweGjwpC6TIyUiVdfCjaR/NAQ2RpdPLVVNFg04w9DpLETOQWzHm/Xky3Xoo36Bk2zEKtTWQG8kXDn0s4yLEKexMPSIgEBTEpZAhfUdUJ8g23AgkxwE4R+kXu6xYAsyMixcdr9tIOONB401giyrJt2xavebjwSlUVROM8sYclqs5rW1RNSxQtx9Msu7x4DYsp13slUpfsEtWX3BIhuW6Z/ALL0YSszKQJRUxGEUXMiv5VKv/2m/gDf6ujKHNuVVwAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all
I'm updating the kernel on my kurobox and I'm stuck with an error when I try to compile the dts file, here is the exact error:


# dtc -f -I dts -O dtb -o kuroboxHG.dtb -V 16 kuroboxHG.dts
DTC: dts->dtb  on file "kuroboxHG.dts"
kuroboxHG.dts:21 syntax error
FATAL ERROR: Couldn't read input tree

even if I remove line 21 I get:

# dtc -f -I dts -O dtb -o kuroboxHG.dtb -V 16 kuroboxHG.dts
DTC: dts->dtb  on file "kuroboxHG.dts"
kuroboxHG.dts:28 syntax error
FATAL ERROR: Couldn't read input tree

sorry, but I'm totally ignorant about dts syntax and can't correct any error.
Any help will be greately appreciated :)

regards,

-- 
Matteo 'Peach' Pescarin
