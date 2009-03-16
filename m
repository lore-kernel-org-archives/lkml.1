Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZCPUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZCPUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZCPUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:25:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:51560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZCPUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:25:09 -0400
Date: Mon, 16 Mar 2009 13:26:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] async: remove the temporary (2.6.29) "async is off by
 default" code
Message-ID: <20090316132605.2a4b78e3@infradead.org>
In-Reply-To: <tkrat.92d38dd320374c4d@s5r6.in-berlin.de>
References: <20090315112345.764fc4ac@infradead.org>
	<20090315112438.79f40526@infradead.org>
	<tkrat.92d38dd320374c4d@s5r6.in-berlin.de>
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

On Mon, 16 Mar 2009 20:29:04 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> (async_manager_thread, NULL,
> >  				      

DOh brown paper bag time.

This is so bad that I feel I need to redo the original patch; I'll
credit it to you though.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
