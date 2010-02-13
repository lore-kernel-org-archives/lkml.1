Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab0BMTxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:53:50 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:37866 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab0BMTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:53:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PkbUSIylMJhzMsuch3rxA0Ej023mvq1epe4nOltJUs6SOtrSnT5zHRmipEUb51008T
         XStwzlrlkZtG/C+U3xBUv5AGLdj+ILKlz7ON6xTZWmYIwGAtSCFQAAQPhTEZ5Hv/KfKh
         M3a8uuGhfJJjzFmlzzuIGdKZwVVEysQcbDpnw=
Date: Sun, 14 Feb 2010 01:24:44 +0530
From: Rabin Vincent <rabin@rab.in>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ftrace: re-enable dynamic ftrace for ARM
Message-ID: <20100213195444.GA31190@debian>
References: <1264959196-5175-1-git-send-email-rabin@rab.in>
 <1264959196-5175-2-git-send-email-rabin@rab.in>
 <20100201102843.GA31714@pengutronix.de>
 <20100201165318.GA1846@debian>
 <20100201211101.GB26532@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100201211101.GB26532@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:11:02PM +0100, Uwe Kleine-König wrote:
> That's OK for me.  Then the only thing that would be nice would be some
> more documentation.  E.g. how looks the function prologue in the two
> cases, which of these instruction is patched?
> 
> This doesn't need to be a stopper for your patch, it's on my long term
> todo list already to add some documentation to the (non-dynamic) ftrace
> on arm.  I wouldn't mind to add the documentation myself, but not now.

I've add this documentation (among other things) in the updated patch
set I've just posted.

Rabin
