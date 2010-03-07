Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0CGTEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:04:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:44378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0CGTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:04:47 -0500
Date: Sun, 7 Mar 2010 11:04:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Fabian Korak <fkorak@stud.fh-offenburg.de>, linux-kernel@vger.kernel.org
Subject: Re: Perf doesn't accept i915:i915_gem_request_wait_begin as an
 event
Message-ID: <20100307110441.50dca8cd@infradead.org>
In-Reply-To: <4B93F813.9080707@linux.vnet.ibm.com>
References: <4B93BF8C020000DD00024397@tula.rz.fh-offenburg.de>
	<4B93F813.9080707@linux.vnet.ibm.com>
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

On Sun, 07 Mar 2010 11:01:39 -0800
Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
> I find the example given on that web page quite confusing because
> perf currently doesn't have support for arch-dependent events like
> that, except via "raw code" events which use the syntax -e
> r<hex_code>. I wonder if they locally modified perf to handle those
> events, and then forgot that they had made that modification before
> posting up those instructions.

these are just standard trace points...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
