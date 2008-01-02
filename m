Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYABEFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYABEFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYABEFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:05:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:14180 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYABEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oKTVhFLqO9sRfbvQQfXZdKycfkgch0wjG7LLWmffNVAF37FG9jCDXQo6cRZvJojZ+RlWDgnfFKAHMxH8ci6HTaRjau5PaBOrrmYGRFDFVbKKzLS48Ky17LIbhxEGaCFpKITzpOAY2KenLLMOsekxbvv3zSPgRxo+zHEti+/qyGE=
Date: Tue, 1 Jan 2008 20:08:28 -0800
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix errors detected by checkpatch.pl on nmi_int.c
Message-ID: <20080102040828.GC18868@localhost.physics.ucla.edu>
References: <20080102010549.GA23991@localhost.physics.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102010549.GA23991@localhost.physics.ucla.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  1.Jan'08 at 17:05:49 -0800, Carlos R. Mafra wrote:
> This patch fixes most errors detected by checkpatch.pl.
> [...]

As pointed out by Jesper Juhl, my patch was not inlined :-(

I did set up mutt especially to send this patch (instead
of thunderbird), and I did test it before sending (and it 
applied correctly).

However I did not notice that it was not inlined because
mutt automatically displays attachments inline. 

Do you want me to send it again (inlined) and with the
Reviewed-by: line?

Thanks in advance,
Carlos

PS: The version I sent to lkml was a new version,
containing also the two-empty-lines -> one-empty-line 
cleanup suggested by you.
