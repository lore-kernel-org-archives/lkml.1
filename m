Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbXLCUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbXLCUCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXLCUCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:02:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:33188 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbXLCUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oh5jD4Gxfkt69vPMeYvE+dcFuAjdl0BuWZIiOHnGAZ7HOFNxFBhXeZdCw2hFdMhqVgl3249A/mXBBMtBsM6M+ZV+HyaXj6v/gCphomHJTXv4yrhA5YPQOa7ep1LTiGXMuUxp/pSThRBb2Z8bwI/WcRZMKLcFbE4HNhO3UTJlB4M=
Message-ID: <cd73a99e0712031202u71efc0e1g8cf910760475bb5d@mail.gmail.com>
Date: Mon, 3 Dec 2007 22:02:33 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH][AT91] Fix compile error for at91rm9200 in latest git
Cc: "Jan Altenberg" <jan.altenberg@linutronix.de>, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <200712031053.43316.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196675122.3832.18.camel@bender.lan>
	 <200712031053.43316.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> Which is a combination of two patches, which seems to have dropped the
> chunk you show below.  The reason this seems to have my signoff is
> that I originated one of those patches, and parts of the second, but
> in fact I had never seen f230d3f53d72d05bcb5666ab7e2eccd49c8b3a15
> until after this email ...

I guess in my rush to get those patches submitted before leaving SAN
People I missed that chunk.  Sorry.

David: The Signed-off line was kept as-is to keep the attribution correct.


> Your patch looks correct, and seems to be the only obvious chunk
> that's missing.  So, I'll ack it FWIW ... usual policy for these
> patches is to go through Russell.

You can add my Ack for what it's worth.


Regards,
  Andrew Victor
