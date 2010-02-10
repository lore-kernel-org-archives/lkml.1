Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0BJArW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:47:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1927 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab0BJArU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:47:20 -0500
Subject: Re: [PATCH 1/1] SCRIPTS: Fix whitespace in get_maintainer output
From: Joe Perches <joe@perches.com>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-crypto@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1265762223-21006-1-git-send-email-richih.mailinglist@gmail.com>
References: <1265762223-21006-1-git-send-email-richih.mailinglist@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 16:47:19 -0800
Message-ID: <1265762839.2131.46.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 01:37 +0100, Richard Hartmann wrote:
> -	    warn "$P: file '${file}' doesn't appear to be a patch.  "
> +	    warn "$P: file '${file}' doesn't appear to be a patch. "

One space not two after periods?  Horrors.

Well if you like, but that's not what I like.

Not-acked-by-but-not-specifically-rejected-by etc.

cheers, Joe

FULL STOP

