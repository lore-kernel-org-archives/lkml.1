Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXCZL4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXCZL4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXCZL4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:56:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54849 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbXCZL4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:56:18 -0400
Date: Mon, 26 Mar 2007 03:55:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rudolf Marek <r.marek@assembler.cz>,
       Alexey Dobriyan <adobriyan@openvz.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] MSR: Add support for safe variants
Message-Id: <20070326035531.a49aa5bb.akpm@linux-foundation.org>
In-Reply-To: <20070326132937.7d518c08.khali@linux-fr.org>
References: <20070325141823.c0e9c4c7.khali@linux-fr.org>
	<20070325142215.eff3af8f.akpm@linux-foundation.org>
	<20070326132937.7d518c08.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 13:29:37 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> The patch from Rudolf Marek which I am posting here builds on top of
> what is already in Linus' tree. Taking it in your tree should not cause
> any problem.

OK, thanks - I'll add this then I'll un-revert the patch which uses it.
