Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZGGOoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZGGOoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbZGGOop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:44:45 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:63514 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbZGGOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uSxY8HZp1SCj+Dn068y2Vtdj4OsO+SaIRWU5MXrOlL2i5iFSMqTz27c2JRG5VP3W6J
         2+HQsWh0uw/zdrAhqM7VmFJQcprxsrul7oc3HUctBBznAbXnFIlSHmbytAqQOjtBrKP8
         sYJZPVgZpVCWCZQQbqMZZ1F1DpBqijWyS+Uxo=
MIME-Version: 1.0
In-Reply-To: <a5d9929e0907070722j563cf485j720274e776f736e4@mail.gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.5zE.DjASKB@chimera>
	 <a5d9929e0907011336g31599a29hca3c204f1b53b775@mail.gmail.com>
	 <2375c9f90907070705p1ae6ebe4x61bda34dd072c1c@mail.gmail.com>
	 <a5d9929e0907070722j563cf485j720274e776f736e4@mail.gmail.com>
Date: Tue, 7 Jul 2009 22:44:42 +0800
Message-ID: <2375c9f90907070744t6a8079bfi827d0c1a1697cb10@mail.gmail.com>
Subject: Re: [Bug #13660] Crashes during boot on 2.6.30 / 2.6.31-rc, random 
	programs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 10:22 PM, Joao
Correia<joaomiguelcorreia@gmail.com> wrote:
> Already testing the changes, just to see if something else breaks.
>
> Any special notes on the patch (a basic guideline info on patches
> would be great, just so i dont mess it up)? Never submited one before.

Yes, check Documentation/SubmittingPatches and Documentation/email-clients.txt.

I am not sure if Peter likes them, but it is a good idea to split them
and send one by one.

Good luck!
