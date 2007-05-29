Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbXE2VrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbXE2VrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbXE2Vqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:46:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:39398 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXE2Vqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YsmAi9Q/FHrpb3C9X8pFe+kqwYLuobnraQ+L9G8JUluDQmC2zVE9cy+rlCoSkBI/8flWOdpU0Q/d4vn3ERXC3Efzv326uZi018zJRTNy8BseZjtd91lRaCLnRWclBQ+dPHRGH7BarwEAzoBPhJWHurRdArIQyz7KytrusYqyfUI=
Subject: Re: Nvidiafb issues on Inspiron 8100
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000705291312v258a4b40u3886ffec3bedea02@mail.gmail.com>
References: <200705240137.35955.dtor@insightbb.com>
	 <1180129321.4627.17.camel@daplas>
	 <d120d5000705291312v258a4b40u3886ffec3bedea02@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 05:46:40 +0800
Message-Id: <1180475201.4455.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 16:12 -0400, Dmitry Torokhov wrote:
> On 5/25/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Thu, 2007-05-24 at 01:37 -0400, Dmitry Torokhov wrote:
> > > Hi Antonino,
> > >

> You know, I disabled Nvidia's DDC stuff and enabled firmware EDID
> again and it started working fine, even without
> video=nvidiafb:1600x1200MR on the command line that I had for a long
> time.
> 
> So it works fine now. Would you oppode adding dmi check for inspiron
> 8100 to automatically disable nvidia i2c support at runtime?

I have no problems with that.

Tony


