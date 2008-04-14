Return-Path: <linux-kernel-owner+w=401wt.eu-S1764520AbYDNR4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764520AbYDNR4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYDNR4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:56:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:26640 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYDNR4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WV4kiGnjw4f4Y01uxQ4GEe9SfUSiemuY6kvOmX4w59eIJbGezc+nETR/5DXmLxkugmCaNk2EVLT2Jlw9yFw85OHme1b3dFyRNQQ6mdHzcFXEJjt9u2OgNth1zcsYFuYVOfvbgNhAMpoMHmYvV5QKu/PXB1o8rGcZMuFN51L0RBs=
Message-ID: <6101e8c40804141056rff5a160jcabb3deebf9b7b6f@mail.gmail.com>
Date: Mon, 14 Apr 2008 19:56:35 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch] eventfd/kaio integration fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Jeff Roberson" <jroberson@chesapeake.net>
In-Reply-To: <Pine.LNX.4.64.0804131555550.12741@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
	 <6101e8c40804130529k353a46a9h8ed1b5fbf6451297@mail.gmail.com>
	 <Pine.LNX.4.64.0804131555550.12741@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this race presented in forigen kernels or only in 2.6.25-rcX?

I added this patch for "queue-2.6.22.y"
http://repo.or.cz/w/linux-2.6.22.y-op-patches.git

On 4/14/08, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Sun, 13 Apr 2008, Oliver Pinter wrote:
>
> > for 2.6.22.y ?
>
> You may want to talk to either Greg KH or Chris Wright for that.
>
>
>
> - Davide
>
>
>


-- 
Thanks,
Oliver
