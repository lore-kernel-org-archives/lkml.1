Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbXCEQje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbXCEQje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933569AbXCEQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:39:34 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:40776 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbXCEQjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:39:33 -0500
Date: Mon, 5 Mar 2007 11:39:29 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Venkat Yekkirala <vyekkirala@trustedcs.com>
cc: "'Eric Paris'" <eparis@parisplace.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       jmorris@namei.org, Venkat Yekkirala <vyekkirala@tcsfw4.tcs-sec.com>,
       cxzhang@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>
Subject: RE: [PATCH] xfrm_policy delete security check misplaced
In-Reply-To: <001501c75f3f$243a3000$cc0a010a@tcssec.com>
Message-ID: <Line.LNX.4.64.0703051139040.14821@d.namei>
References: <001501c75f3f$243a3000$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Venkat Yekkirala wrote:

> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Venkat Yekkirala <vyekkirala@trustedcs.com> 

What about your previous comment:

 "I guess you meant to do this here?
        else if (err)
                return err; "




-- 
James Morris
<jmorris@namei.org>
