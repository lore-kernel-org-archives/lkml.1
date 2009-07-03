Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZGCKFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZGCKFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZGCKE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:04:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58986 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbZGCKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:04:57 -0400
Date: Fri, 3 Jul 2009 11:06:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703095432.GC21141@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
	<20090703064518.GA30674@elte.hu>
	<20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
	<20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your method leads to stuff like this in a recent commit:

Which is a cut and paste of code from the originals into the helper.

> Also note the inconsistent printk-ing lines, mutiliated by line 
> warps. The use of pr_warning() would solve it:

Send patches if it bugs you that much. It's rather lower on my agenda
than pressing things like "if I do xyz to a tty then 2.6.29 crashes"
grade sutff.

Alan
