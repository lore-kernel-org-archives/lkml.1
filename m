Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab0BLFWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:22:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:58424 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0BLFWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:22:51 -0500
Date: Thu, 11 Feb 2010 21:24:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Wojciech Ploskonka <wploskonka@gmail.com>
Cc: Dimitrios Apostolou <jimis@gmx.net>, thomas@archlinux.org,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100211212415.2eace0c2@infradead.org>
In-Reply-To: <4B747D7D.2070002@gmail.com>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
	<20100112160734.89ee6b11.akpm@linux-foundation.org>
	<20100112213205.7d74808a@infradead.org>
	<alpine.LNX.2.00.1002102245200.1675@localhost.localdomain>
	<20100210205637.63131c24@infradead.org>
	<alpine.LNX.2.00.1002111929300.1668@localhost.localdomain>
	<4B747D7D.2070002@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 22:58:21 +0100
Wojciech Ploskonka <wploskonka@gmail.com> wrote:

> 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394
> Controller (rev 05) (prog-if 10 [OHCI])

08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
(rev 05) (prog-if 10 [OHCI])

is the one having PME+ set.

Len: how do we handle PME's again?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
