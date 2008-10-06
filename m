Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYJFWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYJFWLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYJFWLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:11:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40278 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbYJFWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=vh32J/sKAxQSc5mIcUZsW5pY+318yhfaMO7U2NRoXP3krkDgTrFBzrtTQoyWNDoYeB
         R8z97pmxbG502bIYu91HrRU8RHVACPxfw6yI2r1E0B9UotRP6GNCBRVWTKfzvFMHQa+a
         oQha3Om9prDio1vp/Z/YLNfY+GMWE2gi/G2wM=
Message-ID: <97c95c3d0810061511o12f969f1o5ce208184916b867@mail.gmail.com>
Date: Mon, 6 Oct 2008 22:11:28 +0000
From: "Boris Fersing" <kernel.sensei@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: bad DMAR interaction with iwlagn and SATA
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just subscribed to the mailing list, I can't quote the previous
messages. I'm answering to this thread :
http://www.gossamer-threads.com/lists/linux/kernel/976913

I've the same problem here with my Lenovo T400.

I tried 2.6.26 kernels and the 2.6.27-rc8.

The bug occurs with the e1000e module while running the 2.6.26 kernel
and with iwlagn while running the 2.6.27-rc8 (I didn't build the
2.6.27 e1000e module, because of the nvram bug)

Here is some dmesg output, the last one is from the 2.6.27 kernel :
http://boris.geekjide.com/messages0.txt

I'm running a 64bits Gentoo system

regards,

Boris Fersing

-- 
$ ruby -e'puts " .:@BFegiklnorst".unpack("x4ax7aaX6ax5aX15ax4aax6aaX7ax2 \
aX5aX8axaX3ax8aX4ax6aX3aX6ax3ax3aX9ax4ax2aX9axaX6ax3aX2ax4 \
ax3aX4aXaX12ax10aaX7a").join'
