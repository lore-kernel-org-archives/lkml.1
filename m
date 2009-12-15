Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZLOARB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZLOARB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbZLOAQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:16:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:42920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280AbZLOAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:16:58 -0500
Date: Mon, 14 Dec 2009 16:19:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux  Kernel
Message-ID: <20091214161922.6f252492@infradead.org>
In-Reply-To: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
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

On Mon, 14 Dec 2009 15:11:47 -0800
Salman Qazi <sqazi@google.com> wrote:


I like the general idea, I have one request (that I didn't see quite in
your explanation): Please make sure that all cpus in the system do
their idle injection at the same time, so that memory can go into power
saving mode as well during this time etc etc...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
