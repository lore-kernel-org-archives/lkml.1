Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXFDSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXFDSeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbXFDSeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:34:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:38713 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbXFDSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZH8H75RXgIh1nQluBKr/zineZFdceyg1EyXTw+hEcod8yJ1ZcBxfampb4ELumO+ogU2yFIvpPeg92DrGe11TPUNuSdiaqf2yu0r2rFnRoHvM8QDDxZcceV3oT3H2Ms8V/dp3zXvJD02KQfr4jOaETIvOzuhbanPW9Fa527WvV3A=
Message-ID: <4cefeab80706041134l600608bdg5d277aa6da8cf579@mail.gmail.com>
Date: Tue, 5 Jun 2007 00:04:03 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Cc: "Richard Purdie" <rpurdie@openedhand.com>,
       akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <200706041337.51563.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
	 <1180975976.6313.133.camel@localhost.localdomain>
	 <200706041337.51563.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys, please calm down :)

I now understand the memory alignment/other problems that author
pointed out and I am working on same - will post version 7 soon.

Thanks,
Nitin
