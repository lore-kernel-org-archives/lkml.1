Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZCFASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZCFASf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZCFASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:18:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:41240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZCFASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:18:23 -0500
Date: Thu, 5 Mar 2009 16:18:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Robinson <andr345@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Message-ID: <20090305161837.6ba80cc1@infradead.org>
In-Reply-To: <1236192430.6785.111.camel@andreas-laptop>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	<ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	<200902181528.29697.rusty@rustcorp.com.au>
	<ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	<1234952753.10531.48.camel@andreas-laptop>
	<cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	<ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	<1235216636.7025.1023.camel@andreas-laptop>
	<1236004353.10055.49.camel@andreas-laptop>
	<20090302082003.1bb7bdc5@infradead.org>
	<ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	<20090302102703.50aaf724@infradead.org>
	<1236192430.6785.111.camel@andreas-laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Mar 2009 19:47:10 +0100
Andreas Robinson <andr345@gmail.com> wrote:

the only thing I can say (the graphs are a bit complex to read) is that
you are loading a LOT of very expensive modules that bring you no
functionality.
Also I'd love to have seen the scenario where the modules were just
build into the kernel; that gives usually a more reliable indication of
what is going on...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
