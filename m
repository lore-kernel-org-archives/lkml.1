Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbZLKLTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbZLKLTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZLKLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:19:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:27115 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbZLKLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lvmsNkk6yG9fSjpz3Mb6Okp/1mIOkkI039vuUUBEU3r8+hiKh2FV6JncaJqxWEucQm
         Zwosdf+YhEvggdWhR942Ufk+2KGP6r/GLEtCEllVUvvAKaYMYigQJ0pHyp8JLtX5F00p
         zFhf/iNKs+G2c4a58xq2BbCWestdRf/LGXyRg=
Date: Fri, 11 Dec 2009 12:19:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] tracing: add checks for printing graph irq
Message-ID: <20091211111946.GC5244@nowhere>
References: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:38:35PM +0800, Wenji Huang wrote:
> Check return value of trace_seq_printf.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---


I'm applying it, I'll send the fix for the problem you've reported
at the same time.

Thanks.

