Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZGCJoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZGCJoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZGCJoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:44:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41382 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817AbZGCJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:44:03 -0400
Date: Fri, 3 Jul 2009 10:44:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703091655.GB3902@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
	<20090703064518.GA30674@elte.hu>
	<20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
	<20090703091655.GB3902@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well i noticed such details in your final commits that go upstream 
> as well - you dont appear to be making full use of the patch quality 
> tools we have.

Quite often deliberately. A lot of the tty patches keep whatever style
they are patching. You'll then see a single big patch to clean the style
of the entire file up instead of creating the horrible mishmashes of
styles found in some of the code.

> (Also, the patch carried your Signed-off-by - which we add if we 
> consider patches worthy for upstream.)

Fair point

Alan
