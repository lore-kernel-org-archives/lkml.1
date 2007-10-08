Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbXJHPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbXJHPgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXJHPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:36:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:47445 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXJHPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=N0XHr4qvWKqsQ0taxvB/hdmDfWSj1RrywJyVOGeZ3zQ5qxgaPZrf6e33JYfEcFHENptSjsCyz3aEpYqQj+JVZtyc1nba3ArC3Tzx3xNhlzFRF/2boJHlJtfoGttTtgMHHXtuB1vKkEtt/iQrTOCM5H2lrytIme7sOYyrHFt5n3A=
Message-ID: <470A4E64.9060005@gmail.com>
Date: Mon, 08 Oct 2007 17:36:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/1 try 2] V4L: rocket, switch sleep_on to completion
References: <1516924190387627638@pripojeni.net> <1191857509.5564.55.camel@gaivota>
In-Reply-To: <1191857509.5564.55.camel@gaivota>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2007 05:31 PM, Mauro Carvalho Chehab wrote:
> Hi Jiri,
> 
> The patch might be right, however, AFAIK, this has nothing to do with
> V4L. Better to change the subject ;)

Aha, you're right, forgot to change it to Char after V4L patchset :).

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
