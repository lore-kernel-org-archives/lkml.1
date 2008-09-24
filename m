Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYIXVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYIXVnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYIXVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:42:52 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:35037 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751517AbYIXVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:42:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u3ZoAFI+DK2WompaiV5UEAGvSJY24OKUb/fYNcpo07svhrdBaBTxgwoyaPimiJMnKtp2+r0tPpAD37TB/r8hAqFcDKhARlO7yN2e2x1+fxYdqoOy3WG6HbCDxF/aPFvhTy5YyMwBNEzYSmNgOAsLQoO5mHJ1oD7vPgnnv3eyRoc=  ;
X-YMail-OSG: 3w0URRcVM1nCGi0TmSJKENKTEiZNHJxPeAcWQ.pZ84_cv8pKptFlH7pzWDh5JCSqTFJj9L3CPzjX.laD3vbrv6I_VaBXV1c09T_wbxO.3idTjHjrtyw48Ejt2ih_ggTuUyw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Joakim Tjernlund" <Joakim.Tjernlund@transmode.se>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controllerdriver
Date: Wed, 24 Sep 2008 14:42:48 -0700
User-Agent: KMail/1.9.9
Cc: "'Li Yang-R58472'" <LeoLi@freescale.com>, avorontsov@ru.mvista.com,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <1219916613-28827-1-git-send-email-leoli@freescale.com> <200809241328.35008.david-b@pacbell.net> <07ab01c91e8c$b56f6140$204e23c0$@Tjernlund@transmode.se>
In-Reply-To: <07ab01c91e8c$b56f6140$204e23c0$@Tjernlund@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809241442.49240.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008, Joakim Tjernlund wrote:
> > > I see. If one wants to connect with CDC to Windows, what drivers are
> > > there for Windows that works well with Linux?
> > 
> > I believe MCCI has some.  It also has drivers for a CDC subset,
> > pretty much the same one Linux has used forever except wrapped
> > with a few extra descriptors to make it practical to identify
> > that "SAFE" (!) subset without needing vendor and product IDs.
> 
> Thanks, had a look and it seems like I have to buy these drives. I was
> hoping to find some free ones, do you know of such free drivers?

No, sorry.  Remember MSFT is somewhat rabidly anti-Free...

However, we'd be quite happy to have someone more attuned
to MS-Windows sort out the remaining issues in the Linux
support for RNDIS.  ;)

- Dave

