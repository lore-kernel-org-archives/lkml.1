Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbZD0Xse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbZD0Xse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbZD0XsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:48:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:17272 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbZD0XsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v6H4HGCpD0hrcbP+pmrkSSw22LCkzVIj7c5NgeYdY/jywyfyT+FU591SKI6rUSYtAe
         sHYQf6fxfojMZQ/WU+eGMwgU5lzIDCSodOwVKm0jT0yoOaeqegWT9acjTY5zjYIgC/5F
         BgkcGA/9KrmO+Llw+dVOpqW1oHxwis9/vc4qM=
MIME-Version: 1.0
In-Reply-To: <20090427194441.10bac23d@tleilax.poochiereds.net>
References: <20090427205742.GA888@foursquare.net>
	 <20090427221121.GD3036@sequoia.sous-sol.org>
	 <20090427194441.10bac23d@tleilax.poochiereds.net>
Date: Mon, 27 Apr 2009 18:48:06 -0500
Message-ID: <524f69650904271648h6eb08454u9d9b186a5530ecec@mail.gmail.com>
Subject: Re: fs/cifs/connect.c fix missing in latest stable
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Chris Frey <cdfrey@foursquare.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 6:44 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Mon, 27 Apr 2009 15:11:21 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
>
>> * Chris Frey (cdfrey@foursquare.net) wrote:
>> > Hi Chris,
>> >
>> > The latest stable release 2.6.29.2 appears to be missing Jeff Layton's
>> > fix in commit f083def68f84b04fe3f97312498911afce79609e (in Linus's tree).
>> >
>> > I'm not the expert... I just noticed that this was mentioned on
>> > full-disclosure: http://marc.info/?l=full-disclosure&m=123936563230145&w=2
>> > (near the end of Andreas's post)
>>
>> Yes, I think cifs developers are still doing cleanups in that area.
>> Jeff?
>>
>
> Yes, we are but they're pretty close. Some have already gone in and
> some are still outstanding. Suresh J. has done the bulk of the work,
> but there are a few additional fixes for other areas too.
>
> I've been traveling for the last week, and took today off. My plan is
> to get with Steve French tomorrow and finalize a set of fixes for his
> tree that he can push to mainline and stable.

I think Suresh has been out too.  I am only waiting to get some
minor clarifications before I ack the fixes from Suresh.

-- 
Thanks,

Steve
