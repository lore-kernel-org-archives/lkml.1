Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbXHXItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbXHXItS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbXHXItA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:49:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:28234 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbXHXIs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aqD1nSQhWDiQQr58p3cfElFYEkI/TL+ZNG+yVdjjyxPF5saHO+r0Sj8y6pbh9U6WDi1UNQ7q+NVKg6MsPjYCSVRp+Dw/tKWnG5Qu/ikDlKAomVU28tYCLpAxNjGH3tbEDn8aqcqJBKZWiyuAZg3LoYYpe6+dQHhmHn9yN/cFJFs=
Message-ID: <9a8748490708240148oa2431i815e634d8fe6412a@mail.gmail.com>
Date: Fri, 24 Aug 2007 10:48:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 28/30] jfs: avoid pointless casts of kmalloc() return val
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <1187929189.6406.2.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <18983edfb06c7b133f699e34194112ca6a53b14d.1187912217.git.jesper.juhl@gmail.com>
	 <1187929189.6406.2.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/07, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> Thanks, but Jack Stone submitted the same patch a few weeks ago.  It's
> already in the jfs git tree and the -mm kernel.
>
Ok, I wasn't aware of that, but that's perfect.
Sorry for the noise.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
