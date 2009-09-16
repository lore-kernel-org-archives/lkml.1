Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZIPCyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZIPCyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZIPCye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:54:34 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:36769 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZIPCyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Sp3FKQg/qG87Ed52ep6A5VrPcS8hkFY6ZHE3ZCzvSiDWCAMOgtoIWpF/grEF6IoGWC
         MPecCC45MfSPLelGp5KDkHfCupPJabU4VR3Wtn1Sv4jxOdJW6PnPZWXhzQeTMm4zbqrV
         LPNGNKcgSWbmADzbHPEuZvgerSFhtc/J8sBeg=
MIME-Version: 1.0
In-Reply-To: <1252967767.11643.286.camel@desktop>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org> 
	<1252961412.11643.215.camel@desktop> <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com> 
	<1252962263.11643.232.camel@desktop> <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com> 
	<1252963292.11643.259.camel@desktop> <8bd0f97a0909141517i3535bb84j4cbac0cd986d4914@mail.gmail.com> 
	<1252967767.11643.286.camel@desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 22:54:17 -0400
Message-ID: <8bd0f97a0909151954k1061f92dhbc6dcd7a6ccdcdd@mail.gmail.com>
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 18:36, Daniel Walker wrote:
> On Mon, 2009-09-14 at 18:17 -0400, Mike Frysinger wrote:
>> this code i had rewritten and as fallout, the style changed.  looks
>> fine to me, and no, this particular checpatch "error" is not always
>> worthwhile (like in this case).
>
> Have you read Documentation/CodingStyle ? Can you better explain why
> your don't want to follow that document ? Most people accept that to be
> the style of code in Linux, and that is what checkpatch checks for..

sorry, never heard of Documentation/
-mike
