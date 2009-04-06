Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZDFBOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZDFBOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 21:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZDFBOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 21:14:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:48859 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFBOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 21:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pLvMzTIruCZHQUtuksrE48luJ/dT0bXB/A6dnGR9cBNQzUld8LjOm6WQEXXCsPcyQF
         wgvsoxOKvn1J3WYUOt6fqutSRyyboEr4VuWBJuxvPFmObxArqcTA4TuQ8G5el0p+IKvw
         fZSpNk8OlntkLXQuzW+J9eWC6I99wfIEtwglI=
MIME-Version: 1.0
In-Reply-To: <49D89C06.1060700@gmail.com>
References: <20090324150517.GX27476@kernel.dk>
	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	 <20090326084205.GG27476@kernel.dk>
	 <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	 <20090331104933.GJ5178@kernel.dk>
	 <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	 <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>
	 <20090405012839.GF7553@mit.edu> <49D89C06.1060700@gmail.com>
Date: Sun, 5 Apr 2009 21:14:42 -0400
X-Google-Sender-Auth: b059344bfa9e8f8d
Message-ID: <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
From: Lee Revell <rlrevell@joe-job.com>
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 5, 2009 at 7:54 AM, Ric Wheeler <ricwheeler@gmail.com> wrote:
> One thing to point out here is that there are a lot of "servers" in high end
> data centers that do not have UPS backup. Those racks full of 1U and 2U
> boxes that are used to make "grids", "clouds" and so on often are built with
> as much gear as you can stuff in a rack - no batteries or UPS to be seen, so
> they are really quite similar to the normal desktop or home systems that we
> normally run at home :-)

These days even bargain basement data centers provide UPS functionality for
you, via generator backup and A/B power.

Lee
