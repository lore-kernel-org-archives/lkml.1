Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZGCJlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZGCJlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZGCJki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:40:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38681 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757108AbZGCJkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:40:37 -0400
Date: Fri, 3 Jul 2009 10:39:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 8250: Now honours baud rate lower bounds
Message-ID: <20090703103924.45902824@lxorguk.ukuu.org.uk>
In-Reply-To: <20090702223013.GA26960@oksana.dev.rtsoft.ru>
References: <20090702213624.GA23193@oksana.dev.rtsoft.ru>
	<20090702225312.02f78ec4@lxorguk.ukuu.org.uk>
	<20090702223013.GA26960@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about this patch down below?

Thats much better.

Alan
