Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbXGRUf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbXGRUf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbXGRUfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:35:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:10680 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbXGRUfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CxiKTTn8MW5AdjgPdLijSwfkBwwEFFLcQGCFe5VeFNzQouzHeW2c+bOl9XhnVuP6t0gewY47g0Uin6c336aXI4dMnHIYq6d3tyTOS9RGSBiMYEQyzMyPWZGQR5okZj5PvavobLqjPVTbExYtGKCps7pqm652WOjHvWN4h57hcow=
Message-ID: <469E799E.9050201@gmail.com>
Date: Wed, 18 Jul 2007 22:35:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: other potential candidates for removal?
References: <Pine.LNX.4.64.0707180631400.23141@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707180631400.23141@localhost.localdomain>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day napsal(a):
>    a while back, i threw together this wiki page:
> 
> http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed
> 
> feel free to comment.

Stallion drivers

That would be both STALLION and ISTALLION which allegedly have no maintainer and
don't work on SMP (both are listed as depending on BROKEN_ON_SMP). (Were both of
these allegedly dead, or just ISTALLION?)

    Do they work on UP machines? Adrian Bunk 05:04, 18 July 2007 (PDT)

Yes.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
