Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZHMU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZHMU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZHMU6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:58:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355AbZHMU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:58:19 -0400
Date: Thu, 13 Aug 2009 13:56:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feuerer <peter@piie.net>
Cc: linux-kernel@vger.kernel.org, petkovbb@googlemail.com, lenb@kernel.org,
       andi@lisas.de, peter@piie.net
Subject: Re: [PATCH 1/2] acerhdf: convert to dev_pm_ops
Message-Id: <20090813135648.77c99f68.akpm@linux-foundation.org>
In-Reply-To: <20090813121722.48988dfc.peter@piie.net>
References: <20090813121722.48988dfc.peter@piie.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 12:17:22 +0200
Peter Feuerer <peter@piie.net> wrote:

> acerhdf: convert to dev_pm_ops
> 
> v 1.1:
> Add .freeze func ptr to support suspend-to-disk,
> as suggested by Dmitry Torokhov.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Peter Feuerer <peter@piie.net>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Len Brown <lenb@kernel.org>

I believe that Boris wrote this, yes?

The way this patch/email was presented implies that you were the
primary author.

Please use an explicit From: line right at the top of the changelog
(after all the mail headers) to explicitly identify the primary author.

I added a

	From: Borislav Petkov <petkovbb@gmail.com>

to my copy of this patch.  Please let me kow if that was incorrect.
