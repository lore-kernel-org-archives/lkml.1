Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXHWM1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXHWM1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbXHWM1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:27:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:42739 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760908AbXHWM1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d/Ln4Fa7PDXDa2bC6TqMAgcbJTRJUVQuOiUE7Wi7tPqQHVTzufMZsGwqCrBGcpFyb9rcee38A+p2FGgyQe4JwoRHMSrx9dExfYgsnOXr8suTE62hbRxb8bsHjbkg6Woomi55SSEGIXEmsG9GbKe2UDyxptHi8OjP68Sw+E9hoxk=
Message-ID: <9a8748490708230527n753f1c32x2e1c75cd0c090807@mail.gmail.com>
Date: Thu, 23 Aug 2007 14:27:09 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: postfail@hushmail.com
Subject: Re: Ideas on column length in kernel "problem"?
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/07, Scott Thompson <postfail@hushmail.com> wrote:
> I haven't seen any recent solutions to this "problem"...
>
> Many free (and not-free) mail clients wordwrap.  Hushmail wraps at
> 68 (verified), Yahoo has options to wrap at a max of 99, and Gmail
> was somewhere around 85-90 as I recall.  Not sure on other free /
> inexpensive clients.
>
At least for gmail the wrap problem only exists if you try and use the
web interface for sending your patches. If you use a real mail client
like pine, kmail etc to send your patches through gmail (and remember
to use their read/insert file functionality instead of cut'n'paste)
then there is no problem.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
