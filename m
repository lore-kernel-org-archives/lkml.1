Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZJZXpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZJZXpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZJZXpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:45:52 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:55872 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZJZXpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rstWYd7oydR7oHPa+Bsc60wiT86jMlgYmnbwXRjifcJihg/AE3iCieQ6ZBQ7hnThwe
         W+he+O7P9q5KVPSNmbuzmARHl3eCgjXFlx5KvmqJp9UjA1N4CE9clLDCn0R+nNDAd/nV
         Pd94kTY/wvbW3ml8cGzMqxaObs/D5rgQKwoJc=
MIME-Version: 1.0
In-Reply-To: <6dRYo8ss7vL.A.x7E.4qe5KB@chimera>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.x7E.4qe5KB@chimera>
Date: Mon, 26 Oct 2009 17:45:56 -0600
Message-ID: <51f3faa70910261645x16235582keb00a5875f64db14@mail.gmail.com>
Subject: Re: [Bug #14481] umount blocked for more than 120 seconds after USB 
	drive removal
From: Robert Hancock <hancockrwd@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haven't seen the problem again, but I haven't really tried to
reproduce it, and haven't gotten any responses about it, so yes, it
should still be listed.

On Mon, Oct 26, 2009 at 12:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14481
> Subject         : umount blocked for more than 120 seconds after USB drive removal
> Submitter       : Robert Hancock <hancockrwd@gmail.com>
> Date            : 2009-10-21 5:26 (6 days old)
> References      : http://marc.info/?l=linux-kernel&m=125610280532245&w=4
>
>
>
