Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbZCLPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbZCLPT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZCLPTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:19:18 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:51732 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZCLPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UxMGmX6CmrwO0XzEuRzm01cF4KLd+PIJz4jbcp3IAPtYt+j1teIPuvhKIvi2S1mxAo
         H3gTjjNbOZp/qHOmFgViWVfn+j5u0ovtbQkEXStDcLGkOsJqpOR7lgWhBs7FICD5yByY
         Jtk05Wtx7glsAnCFtGSZO0CfFx3/uZJIsQNaQ=
MIME-Version: 1.0
In-Reply-To: <46e1c7760903010350i42d84257lc82c492139607bb8@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <20090211142409.b88c577e.akpm@linux-foundation.org>
	 <46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
	 <20090213210635.d094ffc8.krzysztof.h1@poczta.fm>
	 <20090222081517.567a29bd.krzysztof.h1@poczta.fm>
	 <46e1c7760902220125l61700421gc4045ca10ea4dd10@mail.gmail.com>
	 <20090222164052.dd5442c4.krzysztof.h1@poczta.fm>
	 <46e1c7760902222253p34a714bao5c06b0ad4d779337@mail.gmail.com>
	 <20090228195143.03b1f600.krzysztof.h1@poczta.fm>
	 <46e1c7760903010350i42d84257lc82c492139607bb8@mail.gmail.com>
Date: Thu, 12 Mar 2009 17:19:13 +0200
Message-ID: <46e1c7760903120819s6f1c6695keba84d4315790e36@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: adaplas@pol.net, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I have changed the graphics card on my PC to 3dfx voodoo 3
(tdfxfb), and indeed it made a difference: no cursor. So it begins to
look like the problem only exists on atyfb.

Risto
