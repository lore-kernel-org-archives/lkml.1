Return-Path: <linux-kernel-owner+w=401wt.eu-S1765375AbYBMWbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765375AbYBMWbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYBMWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:31:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbYBMWbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:31:05 -0500
Date: Wed, 13 Feb 2008 14:30:24 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make dump_pagetable() static
Message-ID: <20080213143024.048967c1@laptopd505.fenrus.org>
In-Reply-To: <20080213213131.GA3383@cs181133002.pp.htv.fi>
References: <20080213213131.GA3383@cs181133002.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 23:31:31 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> dump_pagetable() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>


Acked-by: Arjan van de Ven <arjan@linux.intel.com>



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
