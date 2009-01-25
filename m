Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZAYPvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZAYPvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZAYPvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:51:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:11745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZAYPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:51:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u0P3n7+ichAyx4UICuZukxrtm0rQgpLeIkvt46mvOOEiP+SRCEM1vmP/s0KOpzhMxb
         Do1ARMfrFJhny/L938bvaIVhlMNZnjwNJJb3CXwZFvZAFdE4jJDfd6mkAEYI5TXDgYI/
         ZfgY1hoAcHagaF8GRvBw4thFTihFnq+EpDB3M=
MIME-Version: 1.0
In-Reply-To: <20090125134712.GA29757@uranus.ravnborg.org>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
	 <1232866165.3195.1.camel@localhost.localdomain>
	 <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
	 <1232879436.4303.40.camel@localhost.localdomain>
	 <1232880058.4303.46.camel@localhost.localdomain>
	 <93655eb70901250319m334665bew9b5f6738ba6282a7@mail.gmail.com>
	 <20090125134712.GA29757@uranus.ravnborg.org>
Date: Sun, 25 Jan 2009 21:21:44 +0530
Message-ID: <93655eb70901250751p17330aapd4affc01651f34e0@mail.gmail.com>
Subject: Re: building custom module on 2.6.28 fails
From: Satish Eerpini <eerpini@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are currently lacking a dependency on "scripts" so doing:
> make scripts
> make prepare
> is needed today.
>

Just to confirm, ... doing the above works fine and I am able to
compile the module.


Thanks
Satish

-- 
http://satish.playdrupal.com
