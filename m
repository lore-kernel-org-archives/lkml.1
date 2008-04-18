Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYDRAFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYDRAFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYDRAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:04:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbYDRAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:04:53 -0400
Date: Thu, 17 Apr 2008 17:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Moore <paul.moore@hp.com>
Cc: mingo@elte.hu, tglx@linutronix.de, penberg@cs.helsinki.fi,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jmorris@namei.org, sds@tycho.nsa.gov
Subject: Re: 2.6.25-mm1: not looking good
Message-Id: <20080417170407.1e68dfc8.akpm@linux-foundation.org>
In-Reply-To: <200804171955.46600.paul.moore@hp.com>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	<200804171955.46600.paul.moore@hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 19:55:46 -0400
Paul Moore <paul.moore@hp.com> wrote:

> For what it's worth I just looked over the changes in netnode.c and 
> nothing is jumping out at me.  The changes ran fine for me when tested 
> on the later 2.6.25-rcX kernels but I suppose that doesn't mean a whole 
> lot.

Perhaps it was tested only against slub?  That config uses slab.
