Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZL2JnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZL2JnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZL2JnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:43:12 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:61717 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZL2JnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Wxu2BKfPojyh5OFD1k4luvvmgqGoDzfGOnufhqtmSU5fVXrzH7bJXaV8hiplPkL+W9
         c2qX8ZgC13/PbYLnITI4uZ/v0OSSugRpyu2HnSxzDP/5EHEMjglnnLSCsxiA80F/1Ai8
         0mERrkSm6CrY21TQ4OBzGY/XhOfUlqH6vQ+BU=
MIME-Version: 1.0
In-Reply-To: <4B38B786.9020609@hartkopp.net>
References: <Pine.LNX.4.64.0912272227290.20548@ask.diku.dk>
	 <4B38B786.9020609@hartkopp.net>
Date: Tue, 29 Dec 2009 10:43:08 +0100
Message-ID: <cabda6420912290143pfda331en80f8bd77b7816c1@mail.gmail.com>
Subject: Re: [PATCH 4/5] drivers/net/can: Correct NULL test
From: christian pellegrin <chripell@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Julia Lawall <julia@diku.dk>, Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 2:49 PM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>
> Thanks Julia!
>
> I added Christian Pellegrin who is the author of this driver in CC.
>
> An obvious copy/paste error :-)
>

yes, exactly that: copy & paste is among the sweetest evils out there.
I'll try the semantic checker myself next time. Thanks!



-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
