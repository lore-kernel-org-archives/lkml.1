Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbZCaCSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbZCaCSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbZCaCSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:18:23 -0400
Received: from ozlabs.org ([203.10.76.45]:47274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZCaCSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:18:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: linux-next: Tree for March 30 (Blackfin string failures again)
Date: Tue, 31 Mar 2009 12:48:14 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <8bd0f97a0903301726j536da9aciaf9eb5e9a7afff5@mail.gmail.com>
In-Reply-To: <8bd0f97a0903301726j536da9aciaf9eb5e9a7afff5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311248.14413.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 10:56:40 Mike Frysinger wrote:
> On Mon, Mar 30, 2009 at 05:01, Stephen Rothwell wrote:
> > The rr tree lost 8 conflicts.
> 
> was the Blackfin changes related to the string updates lost or
> something ?  the March 30 tree brought in these failures again ...

Sorry, you're right.  I dropped all the arch-specific stuff, I should
have kept that since it had your tested-by.

I'll send to Linus now.
Rusty.
