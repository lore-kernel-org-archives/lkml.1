Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYKIPfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYKIPfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 10:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYKIPfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 10:35:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:40197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbYKIPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 10:35:43 -0500
Date: Sun, 9 Nov 2008 07:36:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: mathias.schnarrenberger@gmx.de
Cc: "Olaf van der Spek" <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: security: delete BIOS password in keyboard buffer during kernel
 bootup
Message-ID: <20081109073630.54496eeb@infradead.org>
In-Reply-To: <200811090941.20401.mathias.schnarrenberger@gmx.de>
References: <200811081100.03966.mathias.schnarrenberger@gmx.de>
	<b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com>
	<200811090941.20401.mathias.schnarrenberger@gmx.de>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 09:41:20 +0100
Mathias Schnarrenberger <mathias.schnarrenberger@gmx.de> wrote:

> > What if my BIOS stores some critical info at that memory address?
> > I don't think the kernel is the right place to work around this
> > issue.
> 
> AFAIK every IBM PC compatible BIOS stores the keyboard buffer in this
> area.
> 
that's a very bold statement...

there are MANY variations of BIOS that are not "IBM PC compatible". In
fact, that's the rule nowadays... they are only "Windows compatible"
often, anything that Windows doesn't use is.. untested at best.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
