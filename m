Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZJGFU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZJGFU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZJGFUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:20:55 -0400
Received: from waste.org ([173.11.57.241]:32847 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZJGFUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:20:55 -0400
Subject: Re: [PATCH 2/8] random.c: Use %pU to print UUIDs
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <f1bf1e935f962ce807a0d70e1657ac778ca833ba.1254884776.git.joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
	 <f1bf1e935f962ce807a0d70e1657ac778ca833ba.1254884776.git.joe@perches.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 00:19:48 -0500
Message-Id: <1254892788.4229.49.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 21:45 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/char/random.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)

Looks good. Been meaning to fix that typo for ages.

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


