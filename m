Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZEQDYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZEQDYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 23:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZEQDYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 23:24:01 -0400
Received: from mail-qy0-f112.google.com ([209.85.221.112]:38851 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZEQDYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 23:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LAy/CbyQ3DPV5j35YTuYEtDh0XWcNLuNuisTsS9pLkIt6lVFCYcWYNLYXaZr8q4+Fr
         Ut5leWvLi2hdL8Awx2nS2k/NB9tAWc55ed+RJaxHQbpkzdVQT/7VzgyTywtOqvQfXqLd
         KwK9mfgUxvPs4iFYbOIUu8U1M7E5sM+a4nJyQ=
MIME-Version: 1.0
In-Reply-To: <1242529603.10835.2.camel@nigel-laptop>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905162107.58677.Martin@lichtvoll.de>
	 <f22f52180905161953t6248e60fg3f6732a04d59b406@mail.gmail.com>
	 <1242529603.10835.2.camel@nigel-laptop>
Date: Sat, 16 May 2009 23:24:01 -0400
Message-ID: <f22f52180905162024s4d946c31j47e237f3ce007f6a@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Matt Price <moptop99@gmail.com>
To: nigel@tuxonice.net
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 11:06 PM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> Hi Matt et al.
>
> On Sat, 2009-05-16 at 22:53 -0400, Matt Price wrote:
>> one of the real frustrations i've had watching this process from the
>> sidelines is that those with the authority to make decisions have
>> never taken either of these very important concerns seriously.  And
>> until they do, I do think it's quite likely that suspend-to-disk will
>> continue in its largely-broken state for quite some time to come.
>
> I just want to talk a little in defence of Rafael - I've found him
> really good to deal with. Yes, he has been headed in a different
> direction, but he's not unreasonable and he is responsive to bug reports
> and suggestions. Please don't think less of him than you ought.
>

didn't really mean to personalize my comments, which on rereading it
appears i may have done.  all i meant to say was that these other
concerns are real issues that make a real difference to the usability
of the code.  and i think it's a shame they aren't (perhaps can't be)
taken into account in these code reviews.

though, echoing martin again, at least in these public threads i've
seen very little specific review of the patches themselves.  i only
hope this is happening on other channels.

matt
