Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbZEGS67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbZEGS67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZEGS5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:57:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41563 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762211AbZEGS5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rqe+Y2Im5W2u3430pimHu9Rxr6VhSqMD4H7RAGmkCh4d2prEX/dz9tv80dPjkL77Pm
         QsZsRX0pJVuOZQ5jW6jawdk7zFKO6MbwvXwl6yGXekzJBbMkf9Cl4js4ruBfen6B2/Y0
         avB9WYHfbegWPFF5KGlYNQC0vyFBvBC85XTAw=
MIME-Version: 1.0
In-Reply-To: <200905072022.15202.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905071945.45928.rjw@sisk.pl>
	 <f22f52180905071052o68e3999co8e353d46aa60b47c@mail.gmail.com>
	 <200905072022.15202.rjw@sisk.pl>
Date: Thu, 7 May 2009 20:57:44 +0200
Message-ID: <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Price <moptop99@gmail.com>, linux-kernel@vger.kernel.org,
       Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 07 May 2009, Matt Price wrote:
>> On Thu, May 7, 2009 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Thursday 07 May 2009, U Kuehn wrote:
>> >> Pavel Machek wrote:
>> >> >> T
>> > Also, as you can see from my previous message, I'm not a big fan of fighting
>> > over this once again.  Lets try to work together to do something productive
>> > instead, shall we?
>> >
>>
>> thank you rafael.  i would really like to see the fighting stop, too.
>> Perhaps the best palce to start would be to look directly at the
>> patches and, if there are weaknesses, discuss how to improve them?
>
> Yes, I've talked about that already with Nigel and there's a kind of a plan.
>

Well, if I may jump in I suggest you start with the full-memory image
functionality. This is in my opinion the biggest advantage in tuxonice
vs. uswsusp.


> Thanks,
> Rafael

Regards,
Fabio



> _______________________________________________
> TuxOnIce-devel mailing list
> TuxOnIce-devel@lists.tuxonice.net
> http://lists.tuxonice.net/mailman/listinfo/tuxonice-devel
>
