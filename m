Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYKCNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYKCNL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYKCNLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:11:17 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:49127 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbYKCNLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:11:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HbDdDrKDUsa9UJ7pRrfkk1GEUBh4bXL86hmq6Kw4bmdWaDl1o0Kj9AaMWFEJgaHasd
         jJ2AzokSgKrs2ALqiMkWjAw3jAJQ5wtH3hv71yQi7G/Hmm2m4gGXFFsTA0DHDWKRGtiu
         8jC8ZWT04FpIAy/kCKivyowqWATF8vvv6NxX0=
Message-ID: <c62985530811030511x311fa9dcy51ce501149abb253@mail.gmail.com>
Date: Mon, 3 Nov 2008 14:11:15 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081103100656.GF13671@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490A08E3.2040201@gmail.com>
	 <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com>
	 <c62985530810301705h356decf8oea0db02def2ab3c1@mail.gmail.com>
	 <alpine.DEB.1.10.0810302241420.21031@gandalf.stny.rr.com>
	 <490B6826.7080604@gmail.com> <20081103100656.GF13671@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> I have a trace in attachment with some good results.
>
> -ENOATTACH
>
> would be nice to see a short comparative section of "before" and
> "after" output within the changelog. That makes the review of such
> changes much more intuitive.



That's right. I forgot it. But I guess it's not relevant anymore
because it made some progress since this last one.
For the next review I will send a comparative between the first and
the last version.
