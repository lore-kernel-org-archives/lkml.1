Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYFOWeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYFOWeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 18:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYFOWeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 18:34:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:51871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYFOWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 18:34:05 -0400
Date: Sun, 15 Jun 2008 15:33:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, sam@ravnborg.org,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] export linux/a.out.h
Message-ID: <20080615153354.44b9d1b7@infradead.org>
In-Reply-To: <1213564021-5195-1-git-send-email-jacmet@sunsite.dk>
References: <1213564021-5195-1-git-send-email-jacmet@sunsite.dk>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2008 23:07:01 +0200
Peter Korsgaard <jacmet@sunsite.dk> wrote:

> Export linux/a.out.h like we do for asm/a.out.h as some applications
> needs it (E.G. valgrind). 

do we know what they need it for?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
