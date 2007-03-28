Return-Path: <linux-kernel-owner+w=401wt.eu-S933674AbXC1WUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbXC1WUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbXC1WUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:20:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933674AbXC1WUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:20:40 -0400
Date: Wed, 28 Mar 2007 15:20:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [PATCH] Fix "Section mismatch" compile warning
Message-Id: <20070328152037.f6d9d4d4.akpm@linux-foundation.org>
In-Reply-To: <20070326151933.GA8765@strauss.suse.de>
References: <20070326151933.GA8765@strauss.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 17:19:33 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> Fix "Section mismatch" warnings in arch/x86_64/kernel/time.c
> 

Please always quote the warnings in the changelog when fixing them, thanks.
