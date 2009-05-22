Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZEVIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZEVIFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZEVIEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:04:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43266 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbZEVIEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:04:52 -0400
Subject: Re: [PATCH] mm/slub.c: Use print_hex_dump and remove unnecessary
 cast
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
       H Hartley Sweeten <hartleys@visionengravers.com>, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <1242840314-25635-1-git-send-email-joe@perches.com>
References: <1242840314-25635-1-git-send-email-joe@perches.com>
Date: Fri, 22 May 2009 11:04:52 +0300
Message-Id: <1242979492.13681.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 10:25 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  mm/slub.c |   34 ++++------------------------------
>  1 files changed, 4 insertions(+), 30 deletions(-)

I am more than happy to merge this patch if the hexdump issues are
resolved.

			Pekka

