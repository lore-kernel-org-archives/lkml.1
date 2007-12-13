Return-Path: <linux-kernel-owner+w=401wt.eu-S1764157AbXLMTQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764157AbXLMTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXLMTQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:16:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:55934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXLMTQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:16:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JhEmB6bfLhgbwi4Pl63B51JuejJ7cWBntxlmvSqNOSa0QigaeH7l9X5Q5RYrzyYD2MlSiG+uTflpBUkqbSCOEc38EAKkIoVIkTL/OGU5d7nk6/GGKhdKjMMa5E8oNd7SPmUkiH1dFujuwET6WlGqvgv8vWpFdFVLx2ePvsfSDWc=
Message-ID: <6101e8c40712131116n6446d564s1046e5f8914e7a0a@mail.gmail.com>
Date: Thu, 13 Dec 2007 20:16:46 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 32/36] XFS: Make xfsbufd threads freezable
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "David Chinner" <dgc@sgi.com>,
       "Lachlan McIlroy" <lachlan@sgi.com>
In-Reply-To: <6101e8c40712131107r23cda32p86d2a3e22a3adcb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213062511.265908583@mini.kroah.org>
	 <20071213063529.GG25301@kroah.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B001520239@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <6101e8c40712131107r23cda32p86d2a3e22a3adcb8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://lwn.net/Articles/235908/

or then drop this patch... while to big change are im kernel
