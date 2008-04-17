Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbYDQHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbYDQHs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbYDQHst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:48:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252AbYDQHss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:48:48 -0400
Date: Thu, 17 Apr 2008 00:48:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417004834.ae757dc4.akpm@linux-foundation.org>
In-Reply-To: <20080416202338.GA6007@elte.hu>
References: <20080416202338.GA6007@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:

>       kgdb: light v16

probe_kernel_address() should be removed and reimplemented using the new
probe_kernel_read().

