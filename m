Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZGTQc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZGTQc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZGTQc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:32:57 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62072 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZGTQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QD2xv55UKvin7/MKOeRm/eamlxidzjiODuexqSjIksKrsKVpQHYeOL1yPNLhrHdAlb
         V8eByTn/0ZjadgUDMCCdqRovDbD1suZb0ibBUgmbVmO+naZ1QYCBkzV0Inecs19yuSAP
         ThFUFH+goPsPn+XfxElLOmcQPBmVJRA73lbWY=
MIME-Version: 1.0
In-Reply-To: <1198385022.260301248106740802.JavaMail.root@mail-01.cse.ucsc.edu>
References: <1279186756.260191248106587108.JavaMail.root@mail-01.cse.ucsc.edu>
	 <1198385022.260301248106740802.JavaMail.root@mail-01.cse.ucsc.edu>
Date: Tue, 21 Jul 2009 00:32:55 +0800
Message-ID: <b6a2187b0907200932n365e016p2212dc126b724424@mail.gmail.com>
Subject: Re: regression: wireless authentication
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Noah Watkins <jayhawk@soe.ucsc.edu>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:19 AM, Noah Watkins<jayhawk@soe.ucsc.edu> wrote:
> The latest version I've tried that works fine is Linus' 2.6.31-rc3
> with the latest commit being:
>
> commit 35b5c55fee08e6e4001ba98060a2d0b82f70b5f4

Mine says 78af08d90b8f745044b1274430bc4bc6b2b27aca which is later than
yours. Wireless working with iwl4965 including WPA2.

Jeff.
