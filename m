Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYEaF3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYEaF3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 01:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYEaF24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 01:28:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:9307 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYEaF2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 01:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O+RXhEsx3IWNSSdMbkfe/iKZzLhbAzSSO/EeJXmtIa4BwKv4tZgOPHj8/wN6AJOBHN4JZw8u6vRdHeeWW8A8p8kfk+VAcRIOCzPa5zlinx048IWiTeGI+blZyf+cdzDDPhH1Gh8TQUiho5KE+9vR5FMrfk1BoBfuoppcGbQjZwQ=
Message-ID: <cfd18e0f0805302228n63cbf0d6l6e7606690ded2315@mail.gmail.com>
Date: Sat, 31 May 2008 07:28:54 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Cc: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <E1K2B2k-0002kS-Cz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu>
	 <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
	 <cfd18e0f0805301243h7d862963o8320a2c1f48942ce@mail.gmail.com>
	 <E1K2B2k-0002kS-Cz@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 10:17 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Michael,
>
>> You omitted to answer my question, the last sentence below:
>
> Oh, come on.  Where in my last mail did I say that these fixes
> shouldn't be applied?

I didn't say you did.  However, while saying "I understand your
frustration", you simply ignored this question, which I would say was
fairly important in the context, and asked me to write another version
of the patch against your tree.  My takeaway from this is that you
attach a higher priority to seeing that your tree isn't broken, than
to seeing that these bugs get fixed.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
