Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYBIQtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYBIQtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYBIQto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:49:44 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:4810 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYBIQtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J48CyX12hdbmahvXPyOcCe54uHraZ5XQVxGOnfqDbn2dVD9G2cFCj4t5BqwlWh6M0AyrKTEwG/NIOG9GH/Agk0H2tzBtQFUUGBDrD6j+lZYTBYfBOdogzCJh2WBmnrbPAbBSH0LfIc8uvRez2+8blWn+gWVUGo3lIiudVRIL2II=
Message-ID: <2f11576a0802090849h1599c4a9jc21bf21c9e7cd947@mail.gmail.com>
Date: Sun, 10 Feb 2008 01:49:41 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: "Jon Masters" <jonathan@jonmasters.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Zan Lynx" <zlynx@acm.org>
In-Reply-To: <20080209114329.68820224@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
	 <B846E82A-D513-40CD-A19C-B60653569269@jonmasters.org>
	 <2f11576a0802090833h7a600ee8x87edb423cbbb5d79@mail.gmail.com>
	 <20080209114329.68820224@bree.surriel.com>
X-Google-Sender-Auth: cf3c4782114ae7cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

> More importantly, all gtk+ programs, as well as most databases and other
> system daemons have a poll() loop as their main loop.

not only gtk+, may be all modern GUI program :)
