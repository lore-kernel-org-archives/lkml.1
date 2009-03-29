Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZC2M1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZC2M1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZC2M1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:27:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42414 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZC2M1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZrrFgyp8NKKcYwzx2WD1aFsrPDf8qsA+5LDwJS6xAaf+fv1RWl+kcclcSv1nityl/1
         zAWvx+7kWpPUiHHPNkLqjIRBUvu+G+WaK+12VC+yoPdHjwXBs7IQrHmdXtiIIc9gqOyb
         1kFylVIZCP0MH6fuqnlPIN7/o3Jws0fr1V0nU=
Date: Sun, 29 Mar 2009 16:27:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
Message-ID: <20090329122752.GF7255@localhost>
References: <20090328102852.GA7697@localhost> <49CEF882.5000005@oracle.com> <20090329064704.GA7255@localhost> <20090328.234739.26481917.davem@davemloft.net> <49CF62A2.6050803@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF62A2.6050803@netfilter.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pablo Neira Ayuso - Sun, Mar 29, 2009 at 01:59:30PM +0200]
... 
| I think that the patch attached is better since it removes the overhead
| of the IPv6 dependency, which is indeed too much for the use of one
| function. Thanks.
| 
...

It's definitely better! Thanks Pablo.

        Cyrill
