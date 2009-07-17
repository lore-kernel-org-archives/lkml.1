Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZGQE3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZGQE3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 00:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZGQE3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 00:29:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:33136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZGQE3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 00:29:36 -0400
Date: Thu, 16 Jul 2009 21:31:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
Message-ID: <20090716213106.32d61d53@infradead.org>
In-Reply-To: <200907170312.00006.rjw@sisk.pl>
References: <1247643516.26272.77.camel@rzhang-dt>
	<20090715060006.71c2e2b6@infradead.org>
	<1247709910.26272.159.camel@rzhang-dt>
	<200907170312.00006.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 03:11:59 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> 
> Well, first, I'm not really sure that using the async _boot_
> infrastructure for that is a good choice. 

the async function call mechanism is for more than boot.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
