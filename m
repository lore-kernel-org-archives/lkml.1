Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZEDM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZEDM54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZEDM5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:57:47 -0400
Received: from static.ip-80-255-245-169.signet.nl ([80.255.245.169]:60467 "EHLO
	mx.dev.iphion.nl" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZEDM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:57:47 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 08:57:46 EDT
Message-ID: <49FEE429.4070902@iphion.nl>
Date: Mon, 04 May 2009 14:48:41 +0200
From: Sven Berkvens-Matthijsse <sven@iphion.nl>
Organization: Iphion BV
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Does a built-in initrd image fall under the kernel license?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a simple question: if I build a Linux kernel and I embed an 
initrd/initramfs cpio.gz image directly into the kernel, do the contents 
of the initrd image fall under the rules of the kernel's GPL license? 
I.e., do I need to release the source code of the contents if I 
distribute the resulting kernel?

Please CC me in any replies, I am not subscribed to this mailing list.

Thank you for your time,
Sven Berkvens-Matthijsse
sven@iphion.nl

