Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbXKPAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbXKPAPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbXKPAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:15:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759161AbXKPAPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:15:35 -0500
Date: Thu, 15 Nov 2007 16:15:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       magotari@gmail.com
Subject: Re: [PATCH 2/4] UML - Remove unused variables in the context
 switcher
Message-Id: <20071115161521.21c4b7f5.akpm@linux-foundation.org>
In-Reply-To: <20071114192049.GA9083@c2.user-mode-linux.org>
References: <20071114192049.GA9083@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 14:20:49 -0500
Jeff Dike <jdike@addtoit.com> wrote:

> This patch removes a variable which was not used in two functions.
> Yet another code cleanup, nothing really significant.
> 
> Please note that I could not test this on x86_64. I don't have the
> hardware for it.
> 
> [ jdike - Bits of tidying around the affected code.  Also, it's fine on
> x86_64 ]
> 
> Signed-off-by: Karol Swietlicki <magotari@gmail.com>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>

I assumed from the above that Karol was the author of this patch.  Please
let me know if that was wrong.

We communicate authorship by putting a From: line at the very start of the
changelog.  If that line is not present then we use the From: from the
email headers.

Thanks.
