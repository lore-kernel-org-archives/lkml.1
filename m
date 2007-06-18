Return-Path: <linux-kernel-owner+w=401wt.eu-S1765896AbXFRS7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765896AbXFRS7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763504AbXFRS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:58:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:26097 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762100AbXFRS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=raNyav95xc+BX4/Fi1M4Xvwu8vXgDLU0N5ROkaKENcRTAnXO68NfL2XgkH3SA6M6PUJIHLGrGmKvbW0RnIjKFZYjoFTMojMHmtcNKjFzbL7uGYTCufQav5nwg/22x2iS1z3qHrRrK0LFLgA1bM3eojkrD23jDF7Embkms6/hhu4=
Message-ID: <6bffcb0e0706181158l739864e0t6fb5bc564444f23c@mail.gmail.com>
Date: Mon, 18 Jun 2007 20:58:54 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 00/26] Current slab allocator / SLUB patch queue
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
In-Reply-To: <Pine.LNX.4.64.0706181102280.6596@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <46767346.2040108@googlemail.com>
	 <Pine.LNX.4.64.0706180936280.4751@schroedinger.engr.sgi.com>
	 <6bffcb0e0706181038j107e2357o89c525261cf671a@mail.gmail.com>
	 <Pine.LNX.4.64.0706181102280.6596@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 18 Jun 2007, Michal Piotrowski wrote:
>
> > > Does this patch fix the issue?
> > Unfortunately no.
> >
> > AFAIR I didn't see it in 2.6.22-rc4-mm2
>
> Seems that I miscounted. We need a larger safe area.
>

Still the same.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
