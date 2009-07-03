Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbZGCRJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbZGCRJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZGCRJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:09:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:43102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZGCRJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:09:44 -0400
Date: Thu, 2 Jul 2009 23:12:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Reminder for feature Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL
 exports removal date before 2.6.19 Nov 2006
Message-ID: <20090702231246.1a144b61@infradead.org>
In-Reply-To: <1246586623.2530.6.camel@jaswinder.satnam>
References: <1246586623.2530.6.camel@jaswinder.satnam>
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

On Fri, 03 Jul 2009 07:33:43 +0530
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Arjan,
> 
> What:   Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
>         (temporary transition config option provided until then)
>         The transition config option will also be removed at the same
> time. When:   before 2.6.19
> Why:    Unused symbols are both increasing the size of the kernel
> binary and are often a sign of "wrong API"
> Who:    Arjan van de Ven <arjan@linux.intel.com>
> 
> If you are facing any issue regarding feature removal kindly update
> the "Documentation/feature-removal-schedule.txt" like what you are
> waiting for.
> 
> Thanks,
> --
> JSR
> 
> http://userweb.kernel.org/~jaswinder/
> 

??

what are you suggesting?

unused symbols are getting marked and later approved as appropriate...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
