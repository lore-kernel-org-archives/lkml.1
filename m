Return-Path: <linux-kernel-owner+w=401wt.eu-S1762698AbXGEU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762698AbXGEU3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759803AbXGEU3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:29:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762632AbXGEU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:29:42 -0400
Date: Thu, 5 Jul 2007 13:29:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-Id: <20070705132928.76783253.akpm@linux-foundation.org>
In-Reply-To: <20070705132120.8edbc1f3.akpm@linux-foundation.org>
References: <20070703164046.645090494@polymtl.ca>
	<20070703164516.377240547@polymtl.ca>
	<20070703181151.GB5800@martell.zuzino.mipt.ru>
	<20070703185748.GA4047@Krystal>
	<20070705132120.8edbc1f3.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 13:21:20 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Please prepare and maintain a short document which describes the
> justification for making all these changes to the kernel.

oh, you did.  It's there in the add-kconfig-stuff patch.
