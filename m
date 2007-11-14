Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbXKNGP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbXKNGP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbXKNGPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:15:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:4056 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372AbXKNGPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:15:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fHJYKKhC0DE+L0zmji46tBi05Wc0HtO/RET4gXPt3yhKN700QxMN7e5y51CJYwsOejL5ryXz5BVnwiiF9192PbOGxd4JrUmKySx3iJrClQcxrBixZmyHh4TPisIljByx/R3sVFLbgqr1yjZyo2oqXNtw049ReNKvIBUzJn0hdMo=
Message-ID: <b25c3fa70711132215q2e5d5d99sb2b03b7bef49c372@mail.gmail.com>
Date: Wed, 14 Nov 2007 15:15:46 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Kok, Auke" <sofar@foo-projects.org>, "Patrick McHardy" <kaber@trash.net>
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "David Miller" <davem@davemloft.net>, w@1wt.eu, cfriesen@nortel.com,
       netdev@vger.kernel.org, djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
In-Reply-To: <473A83AD.6030101@foo-projects.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000001c82679$796d1770$9c94fea9@jason>
	 <473A83AD.6030101@foo-projects.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'll work e1000e too :-)
>
> awesome, looking forward to that.
>

BTW, It seems to need Patrick's unicast patch for e1000e first.
I'll looking forward to that too.

Thanks
Joonwoo
