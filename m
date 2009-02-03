Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZBCRpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZBCRpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZBCRpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:45:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:38082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZBCRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:45:37 -0500
Date: Tue, 3 Feb 2009 09:45:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>, Luca Olivetti <luca@ventoso.org>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
 paging request at ff100000
Message-ID: <20090203094545.315291c6@infradead.org>
In-Reply-To: <20090203172836.GA6964@elte.hu>
References: <20090203172836.GA6964@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 18:28:36 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> FYI, -tip qa keeps triggering this 

can you run this through markup_oops.pl?
that'll give you a full source code dump :)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
