Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab0BRUYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:24:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:52213 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752420Ab0BRUYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:24:12 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+D7JRwnL2D2F00W4X7QAU4KY7uq/K2vgoigbhObY
	sYAX97DY1nYC+9
Date: Thu, 18 Feb 2010 22:27:53 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
cc: Wojciech Ploskonka <wploskonka@gmail.com>, thomas@archlinux.org,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
In-Reply-To: <20100211212415.2eace0c2@infradead.org>
Message-ID: <alpine.LNX.2.00.1002182223270.1847@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> <20100108171513.GB22713@ldl.fc.hp.com> <20100109134352.3dedd4ea@infradead.org> <alpine.LNX.2.00.1001100155370.1325@localhost.localdomain> <20100109160836.26a344a9@infradead.org>
 <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain> <20100109164240.43b21247@infradead.org> <alpine.LNX.2.00.1001100251210.1334@localhost.localdomain> <20100112160734.89ee6b11.akpm@linux-foundation.org> <20100112213205.7d74808a@infradead.org>
 <alpine.LNX.2.00.1002102245200.1675@localhost.localdomain> <20100210205637.63131c24@infradead.org> <alpine.LNX.2.00.1002111929300.1668@localhost.localdomain> <4B747D7D.2070002@gmail.com> <20100211212415.2eace0c2@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Arjan van de Ven wrote:
> On Thu, 11 Feb 2010 22:58:21 +0100
> Wojciech Ploskonka <wploskonka@gmail.com> wrote:
>
>> 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394
>> Controller (rev 05) (prog-if 10 [OHCI])
>
> 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
> (rev 05) (prog-if 10 [OHCI])
>
> is the one having PME+ set.
>
> Len: how do we handle PME's again?

So is this something fixable? Did I lose some email?


Dimitris

