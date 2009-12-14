Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZLNFl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZLNFl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZLNFl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:41:58 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42546 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZLNFl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ja9Xf9CC8CLozgAIMpnvYKxSOnzEd0wcmKgAhjhEYTEag7bXEAyrm36pNqCBSQmf/j
         zV2CCzDKdE49S4OrYZ3hF0LULcnT9GSjzZKxPNOyFQsktpdsWbV02T7NV09oPH8dChGx
         KsIkc0MbKenZTZjFXOw1QnoZzRK9VfYdV+qFE=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
	 <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>
	 <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
Date: Mon, 14 Dec 2009 07:41:55 +0200
Message-ID: <9b2db90b0912132141j6b06d26dgd1e14acf3631de13@mail.gmail.com>
Subject: Re: nconfig v7
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> - I get a visual glitch (see Exhibit A below) in General setup (patch
>>>  slapped onto 2.6.32); the left frame part is missing.
>>
>>I cannot reproduce this. Can you provide some more details? (e.g.,
>>which terminal, $LINES, $COLUMNS, $TERM)
>
> xterm -bg black -fg gray -geometry 80x25

I cannot reproduce this on any of my systems. Any idea how to
proceed?? Can you also send a snapshot?
