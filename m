Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZKBMtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZKBMtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZKBMtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:49:07 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52207 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbZKBMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gGjHWOE2wgn73egx5dVjuzrjZFwKFNQG9ZsMpN3+qAEwjnLQMNRJ63A9aoGa63Vl5+
         YvHALz6E0dh8aUEnuB1M9twG7pYMnxWvG4QXS2ULcbCcEepAxFHFacpd2uK7a8mn68+J
         IrUDyFifyfwgsbLMuCRej+0bX5Uz3F+iuipZQ=
MIME-Version: 1.0
In-Reply-To: <cone.1257159721.959115.3271.1000@onepiie>
References: <20091019102116.222ff9c3.peter@piie.net>
	 <9ea470500910191151j370cec68w67ee8e31f42f3303@mail.gmail.com>
	 <cone.1255986667.852662.3188.1000@deskpiie>
	 <20091020072752.GA9326@liondog.tnic>
	 <cone.1257159721.959115.3271.1000@onepiie>
Date: Mon, 2 Nov 2009 13:49:07 +0100
Message-ID: <9ea470500911020449y3515347em81f8b004b3a899ca@mail.gmail.com>
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <pfe@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In that case, the patch should be applied. I'll give it a run later.
>
> Did you already give it a try?

Yep, sorry for the delay.

Tested-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
Boris
