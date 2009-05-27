Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbZE0PD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbZE0PD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbZE0PDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:03:18 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:39524 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbZE0PDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xt3R4Xx5P/taE7Z3CHoc7XjBHinLRZXvRGtSPJgEcEWOzlZmJcB1XOKlCxF/WczfZQ
         QqdrrIt2mzYo40G5WF4MlvZD1xziYgaKXNavpuopGF2BwEZoFmamk2EXB5el/1/09OLc
         IOJ0omcTXQ+ZxoVW8R5UxVi4J3owxUXTiizGo=
Date: Wed, 27 May 2009 17:03:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gerard Lledo <gerard.lledo@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (linux-next) Cleanups in drivers/staging/comedi
Message-ID: <20090527150310.GD5982@nowhere>
References: <1243434919-10192-1-git-send-email-gerard.lledo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243434919-10192-1-git-send-email-gerard.lledo@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:35:17PM +0300, Gerard Lledo wrote:
> 
> These are 2 small patches that fix one warning and a build faulure in the
> comedi subsystem.  Both of them were build-tested.


Hi,

Don't forget to Cc linux-kernel and also Greg who is
the staging subsystem maintainer.

(adding the missing Cc)

Thanks.



> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

