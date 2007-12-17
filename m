Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXLQRXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXLQRXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXLQRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:23:36 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:49621 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbXLQRXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:23:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=r2I5pN2lnSMITdWYmYZdYQIDGhExxXaTkibEgRyV2VNADdkfQZY5hTNpX3xa7t2p1lPlY5wKsDsTqgAqwgbtgcYoHa/atvLfLMsDXu57zCZj6wBRftlL+Pa8KahKb6iyUjX7PlreVQ+erK1HixsOhTiNUylqrbUveOY1KcyguL0=
Date: Mon, 17 Dec 2007 12:23:27 -0500
From: Vivek Goyal <vivek.goyal2008@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@in.ibm.com>,
       vgoyal@redhat.com
Subject: Re: [PATCH] x86: Unify kexec_{32|64}.h
Message-ID: <20071217172326.GB4492@pasta.boston.redhat.com>
Reply-To: vivek.goyal2008@gmail.com
References: <1197812321.3749.59.camel@brick> <20071217164843.GA13466@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217164843.GA13466@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 05:48:43PM +0100, Ingo Molnar wrote:
> 
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > One section collecting all constant defines.  Ifdef the asm blocks for 
> > X86_32/64.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> thanks, applied. Vivek, does it look good to you too?
> 

Ingo, yes, it looks good to me. My new mail id is vgoyal@redhat.com.

Thanks
Vivek
