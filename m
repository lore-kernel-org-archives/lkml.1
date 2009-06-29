Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZF2PZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZF2PZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZF2PZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:25:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZF2PZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:25:03 -0400
Subject: Re: Kernel testing in a VM good idea?
From: Petr Tesarik <ptesarik@suse.cz>
To: James Dolan <jamesdolan@clear.net.nz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090627185749.065bcab4@linux-uvcl.site>
References: <20090627185749.065bcab4@linux-uvcl.site>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Mon, 29 Jun 2009 17:25:04 +0200
Message-Id: <1246289104.7698.15.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Dolan píše v So 27. 06. 2009 v 18:57 -0400:
> Are there any disadvantages to testing/developing a kernel in a VM ? (i
> luck the availability of hardware) 

AFAICS the only unsurmountable problems you might encounter is timing
and performance. You can't predict how real hardware will work when it
comes to CPU and memory caches, system buses, hardware interrupts, large
CPU counts, NUMA factors, etc. But if any of those were of any concern
to you, you wouldn't have asked, I guess. ;-)

So, no, I don't think there are any important disadvantages when using
virtualized environment.

Petr Tesarik
SUSE Linux


