Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYFLR1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYFLR1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYFLR1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:27:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:34265 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYFLR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=r5ym9cPmOUnkOOfWjpRH0dgq0PfMaUuWL0AgK31YWdwEnjx2PJiETuocOufbOHSogP
         JmwuRkR1xgv6I77Z18AzZvFkPmhPSUsDC0Gose6ok4xJdRHuo90Y6fshpGLDx7XckN3a
         W1qQvAXUEvt45d2TPBohHC4f3hyBJjWtziTIk=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Date: Thu, 12 Jun 2008 19:40:28 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080601193000.GA3056@ime.usp.br> <200806112021.50264.IvDoorn@gmail.com> <20080612042320.GB19980@ime.usp.br>
In-Reply-To: <20080612042320.GB19980@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121940.28882.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Anyway, did you have some time to check your D-Link stick? I am
> > > willing to test more things or other kernel trees, if that is
> > > helpful to the project.
> > 
> > Kernel is compiling right now,
> 
> Nice. Thank you.

Unfortunately I haven't that much time to test it, and the allmodconfig kernel
is still providing the same problems as my usual configuration. I am a bit closer
at tracking this down, but I won't have another shot at this before the weekend :S

Ivo
