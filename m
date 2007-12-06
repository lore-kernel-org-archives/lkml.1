Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXLFX2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXLFX2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXLFX21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:28:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:17858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbXLFX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:28:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mbxy+0pQsPtIMdh3JToW8ECenXdYM9Tf0RYWS8eW2DNZQND4wspUcDLndeLSWJkEHH5QBYzEopVew3/5lrziZPaFR3Ymlo/vrWKYHNWMzXjFIvq6QaBtAZ6cP9qkelW4i1w+X0ngMYIES8mS+A2QyvWFN8uKJ9fiTe+ifnxBkPk=
Message-ID: <a44ae5cd0712061528j4c0ea529w71bd2b96e1e73043@mail.gmail.com>
Date: Thu, 6 Dec 2007 18:28:25 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-mm1: VDSOSYM build error
Cc: "Laurent Riffard" <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20071206143754.07a67819.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <47587796.8020705@free.fr>
	 <20071206143754.07a67819.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can I find Roland's patches, so I can try backing them out?
I looked in the broken out patches and only saw one related
to VDSO.  Backing it out did not help.  I tried searching for
messages to LKML sent by "roland" but mostly got a bunch of
folks sending spam.

         Thanks,
               Miles
