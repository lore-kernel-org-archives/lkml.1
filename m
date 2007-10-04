Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbXJDO0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbXJDO0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 10:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXJDO0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 10:26:07 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:5779 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbXJDO0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 10:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ndTF3p4naY174nDMsph9nBZxkoVbBlJ6b7Myaum6WTqrQjfplZbsB8iY4GotxIxXfhOBNQqEP2b/Ec4yL54N/8ivGfimOQol/MLFTK/AtuXzux4Lb5nvvF4UNd4jpkZ3PFPK6oZxCChUFwxjDqHyJ2rdd+N9hx6rtDwQQAvW/+o=
Message-ID: <a425f86c0710040726q27aeb354vbbcb68bd2fed2b76@mail.gmail.com>
Date: Thu, 4 Oct 2007 17:26:01 +0300
From: "Kalle Pokki" <kalle.pokki@iki.fi>
To: bryan.wu@analog.com
Subject: Re: Blackfin Ethernet MAC driver compile error
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1191489141.6139.1.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a425f86c0710020430o3507eeb2veb104dc936f230dd@mail.gmail.com>
	 <1191489141.6139.1.camel@roc-laptop>
X-Google-Sender-Auth: 09ceecdc55de8848
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/07, Bryan Wu <bryan.wu@analog.com> wrote:
> Sorry for missing the pinmux patches.
> After Linus's git-pull, it should be fixed in the latest Linus mainline
> git tree.

Thanks, it is working now. I was also glad to see the binfmt_flat
patch going in.

Do you plan to get the PHY abstraction layer patches for the Blackfin
EMAC included in the upcoming merge window?
