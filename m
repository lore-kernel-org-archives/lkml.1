Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYAHGvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYAHGvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYAHGve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:51:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:18965 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYAHGvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Z3K0LScBb+KHJvNkDP9sEZP8XOzOgtTgmhtUqpocGn+YRlOAG3htyNENf9dEHaMdmSZYSTpIH/+stJ/b7zgFnebU491a3UyjEja4EVIOYsJS2pcpPUAkPz52I5ESyVLcy/0Rjze2rwYjeDBxXFQEGb2kltbvq9hFbOeRW1IM6TM=
Date: Tue, 8 Jan 2008 07:52:43 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, jack@suse.cz
Subject: Re: [PATCH] udf: convert some macros to functions
Message-ID: <20080108065239.GA23875@joi>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com> <1199580275-2487-6-git-send-email-marcin.slusarz@gmail.com> <20080107122617.GB3710@infradead.org> <20080107204413.GB22144@joi> <20080107152815.acab7678.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080107152815.acab7678.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 03:28:15PM -0800, Andrew Morton wrote:
> On Mon, 7 Jan 2008 21:44:26 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > > There's some overly long lines here and some odd style, this should look
> > > more like:
> > These long lines were split later in "[PATCH 1/7] udf: fix coding style"
> 
> Confused.  How can patch 1/n come "later" than this one?
> 
> Your patches actually came through as "[patch] udf: ...".  ie: no
> sequence numbering.
Because there are 2 patchsets. First in third version and second in first version.
I think I join them to not confuse anyone...

> > (but I will fix it in next version of this patch).
> 
> Please fix the sequence numbering too, thanks.
Yeah. I forgot to do this before submission.

Marcin
