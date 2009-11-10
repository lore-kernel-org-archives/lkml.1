Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZKJUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZKJUER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbZKJUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:04:16 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63245 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbZKJUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jiYsFFisOfeEmREQMi/GZkvu0dobZq6b6zTZP5uZB/dDp5Ir9Sa/MZqt4CY7vIRmV4
         FNMwkJ37Fu/PP9uGsJiKvvGTeAhzro6CUZoUP3HHHgAmWVYkBjJ7OYnIBTKssPUNUlou
         scHoHOjJp0PMxFLe7hTaendwqWTmSdNL2132w=
Date: Tue, 10 Nov 2009 23:04:17 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove asm/apicnum.h
Message-ID: <20091110200417.GE5881@lenovo>
References: <20091110190515.GB5881@lenovo> <4AF9BBB8.8010809@sgi.com> <20091110192454.GB3904@sgi.com> <20091110192852.GD5881@lenovo> <20091110195835.GA4393@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110195835.GA4393@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dimitri Sivanich - Tue, Nov 10, 2009 at 01:58:35PM -0600]
| It doesn't look as though arch/x86/include/asm/apicnum.h is referenced
| anywhere anymore.  Its definitions appear in apicdef.h.
| 
| Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
| 
| ---
| 
|  arch/x86/include/asm/apicnum.h |   12 ------------
|  1 file changed, 12 deletions(-)

Thanks Dimitri,

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

