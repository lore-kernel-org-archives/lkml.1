Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473Ab0AIVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0AIVlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 16:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427Ab0AIVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 16:41:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:36097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0AIVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 16:41:14 -0500
Date: Sat, 9 Jan 2010 13:43:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alex Chiang <achiang@hp.com>
Cc: Dimitrios Apostolou <jimis@gmx.net>, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100109134352.3dedd4ea@infradead.org>
In-Reply-To: <20100108171513.GB22713@ldl.fc.hp.com>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
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

On Fri, 8 Jan 2010 10:15:13 -0700
Alex Chiang <achiang@hp.com> wrote:

> Since you bisected this down to a commit from Arjan, it might
> help to cc him.


please send me "powertop -d" output, as well as the output of
"dmidecode"..... quite possible that that's enough for me to fix this..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
