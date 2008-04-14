Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYDNMku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYDNMku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYDNMkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:40:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:30023 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYDNMkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=xVptr9pj4TdNXJHEl2IzN2pdZaKljnwMf7juVYUuL7FLf4ctwbFsi5g4+SwhNNE5n5xUAisMa5x+qWfmJoHXdeBlXtNPPLuauBK0EUTvi3XPi1IGAO2Up+8egX1+dAA5Fl30u0VMxpEzEiPF+TZHQU5OeALu9do+aO9kcer9ZH0=
Message-ID: <cfd18e0f0804140540i1c6f035o259a7c4635194f54@mail.gmail.com>
Date: Mon, 14 Apr 2008 14:40:40 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: jens.axboe@oracle.com
Subject: CLONE_IO documentation
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Could you supply some text describing CLONE_IO suitable for inclusion
in the clone.2 man page?
( http://www.kernel.org/doc/man-pages/online/pages/man2/clone.2.html
).  In that text it would be helpful to explain what an "I/O context"
is.

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
