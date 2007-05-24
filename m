Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXEXTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXEXTJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXEXTJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:09:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:28739 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXEXTJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EsiEMB2KjU4YzIKWWYVJMGGRXQr24eZi7iOVXSySTMIMLDXjYysqC4nxpMW39pgqk4Z1xGEmaf/E7cM5607dkB1F43OcPAOivEaKVhiNuI5WUY2QK6xgcdM4I8ynyonHYUF5zZrpitxFc9nD8Ht2XddgCjwf47+SnannsnXVhGY=
Message-ID: <84144f020705241209n2919b363i60cfba777e5a757e@mail.gmail.com>
Date: Thu, 24 May 2007 22:09:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Jan Kara" <jack@suse.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Ben Fennema" <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070524115735.a1a2e32e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523184436.GA14771@cvg>
	 <84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
	 <20070524115735.a1a2e32e.randy.dunlap@oracle.com>
X-Google-Sender-Auth: f8dec118389934c8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> but Lindent needs some hand-holding / eyeball help as well...

That's true but the point remains: it would be better to have
whitespace-only fixes first. But if Andrew is willing to eat Cyrill's
patch as-is, I have no real objections either...
