Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYIAOHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYIAOHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYIAOH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:07:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:4064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYIAOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tN02nl8NBeWS/osKp6t0i5GfQvoAS3Awcv/JSXL4/NJ0bXZhuymDMOnRYCwihpswCh
         Nd+AHZZe+NEI2OHhFEDD91IBC9d6zqXqSyHJA206srVeZDv/J29Fb0rq7+S8tsQM17F5
         pVs7i7qHNIw2zuA+A6Jb2WcfbXgoSBDjEAvCk=
Date: Mon, 1 Sep 2008 18:07:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Ingo Oeser <ioe-lkml@rameria.de>, neilb@suse.de
Subject: Re: [PATCH] sunrpc - fixup userspace buffer possible overrun v3
Message-ID: <20080901140723.GA7241@lenovo>
References: <20080831152549.GD2884@lenovo> <20080901011709.GA19834@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901011709.GA19834@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[J. Bruce Fields - Sun, Aug 31, 2008 at 09:17:09PM -0400]
...
| 
| That gives the following:
| 
| --b.
| 
...

Thanks Bruce

		- Cyrill -
