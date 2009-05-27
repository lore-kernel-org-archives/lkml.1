Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZE0I0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZE0I0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZE0I0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:26:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:54428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbZE0I0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:26:05 -0400
Subject: Re: [Patch 2/2] Doc: move Documentation/exception.txt into x86
 subdir
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rdunlap@xenotime.net, mingo@elte.hu
In-Reply-To: <20090527073001.6279.90725.sendpatchset@localhost.localdomain>
References: <20090527072952.6279.72977.sendpatchset@localhost.localdomain>
	 <20090527073001.6279.90725.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 27 May 2009 13:54:58 +0530
Message-Id: <1243412698.3109.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 03:28 -0400, Amerigo Wang wrote:
> exception.txt only explains the code on x86, so it's better to
> move it into Documentation/x86 directory.
> 
> This patch is on top of the previous one.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
> Index: linux-2.6/Documentation/exception.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/exception.txt
> +++ /dev/null

> Index: linux-2.6/Documentation/x86/extable.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6/Documentation/x86/extable.txt

What is the reason of this name change exception.txt -> extable.txt

--
JSR

