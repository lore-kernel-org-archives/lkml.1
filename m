Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0BNRcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:32:19 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:64745 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0BNRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:32:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bgvgkJWpvTPqM6Du9MHNwRmed2DRNUqxwtKANw1zgGWRSa3b+fCIgoewmZimn/Tp2v
         kS2GmAuWm/aZYmeLd/j7KDJhA37MuEZf7fx1v9AeIz64ZBlMJkFjt9uMjYxo5KdsTmmm
         pnXpk9sTyxnN7T2KAJnE/qXwwHY5lKAljLip0=
Date: Sun, 14 Feb 2010 18:32:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing/kprobes: make Kconfig dependencies generic
Message-ID: <20100214173205.GA5479@nowhere>
References: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com> <4B734B37.4000903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B734B37.4000903@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 07:11:35PM -0500, Masami Hiramatsu wrote:
> Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > KPROBES_EVENT actually depends on the regs and stack access API (b1cf540f)
> > and not on x86.
> > So introduce a new config option which architectures can select if they
> > have the API implemented and switch x86.
> 
> Looks good to me:) Thanks!
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>


Queued both, thanks!

