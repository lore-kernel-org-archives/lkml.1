Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZIUHdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZIUHdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZIUHdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:33:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:48674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZIUHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:33:19 -0400
Date: Mon, 21 Sep 2009 09:33:28 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
Message-ID: <20090921093328.75ae5519@infradead.org>
In-Reply-To: <1253517908.25640.37.camel@marge.simson.net>
References: <4AB59CBB.8090907@datenparkplatz.de>
	<alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
	<20090920220405.GA395@duck.suse.cz>
	<1253517908.25640.37.camel@marge.simson.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 09:25:08 +0200
Mike Galbraith <efault@gmx.de> wrote:
> I still occasionally see some largish numbers though, and suspect that
> depends on how much cache was evicted.

if you run latencytop it'll at least tell you what kind of operating
was going on that hit the delay...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
