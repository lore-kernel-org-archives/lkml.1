Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZFGEjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZFGEjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 00:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZFGEjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 00:39:10 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47405 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZFGEjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 00:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l+0iOohYwXTxESB7HwvFjZA5hZ4CW3Hj6FzYRg/ojXQAIiyQvm3nMFkp0CEjOehB/Z
         iG++ZrsuV4TmvNHvRNPte9ga1Q84aQBRdV43MQzCvSE1GkgrkCxhUPbmKuIBn9A3zwP2
         hH+l+AmkbeUQxaSeHp0jD074ZqlBKeP/F7nRo=
MIME-Version: 1.0
In-Reply-To: <4A2AB298.7020603@gmail.com>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	 <c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
	 <20090605100505.41b3b818@lxorguk.ukuu.org.uk>
	 <c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
	 <20090605114245.175499e1@lxorguk.ukuu.org.uk>
	 <4A29C163.3080706@gmail.com>
	 <20090606155636.18bc4f2e@lxorguk.ukuu.org.uk>
	 <4A2AB298.7020603@gmail.com>
Date: Sun, 7 Jun 2009 06:39:10 +0200
Message-ID: <c5bd819b0906062139s4d8eea3eq2fc21f37deb6172b@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/6 Robert Hancock <hancockrwd@gmail.com>:
>
> Thing is somehow the GTM detection isn't working now and it apparently was
> in 2.6.27.1. I'm not seeing any patches to pata_via or libata-acpi that seem
> like they would affect this offhand. Grozdan, would you be able to try git
> bisect to try to figure out what changed the behavior?
>
> CCing Tejun in case he has any ideas..
>

I've no idea how and where to do a git bisect so if someone is willing
to explain in simple steps, I can try...
