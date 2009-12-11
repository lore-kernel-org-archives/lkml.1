Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZLKKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZLKKU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZLKKUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:20:53 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:60276 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZLKKUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TdHQ8Jm8HnDhX8cW4q4WgXOb5uzfvVVk/r1Vxy7SaxUjJgP2QqYHC8C2zIPTYVsl7R
         ryR0PEj63aN6UWdxCp8FiT5cxIVxMJ4hikPSJSeTFiNHh7FBTiGRkWw5Gehp236kLP8p
         oB8ymtcCP092tNZzvWHyftVNvFnTkfMb0c8lE=
MIME-Version: 1.0
In-Reply-To: <20091211.013436.189815985.davem@davemloft.net>
References: <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
	 <20091211091843.0a543136@lxorguk.ukuu.org.uk>
	 <20091211.013436.189815985.davem@davemloft.net>
Date: Fri, 11 Dec 2009 20:20:57 +1000
Message-ID: <21d7e9970912110220u6b61a4e2o306289ae75a5bcc2@mail.gmail.com>
Subject: Re: [git pull] drm
From: Dave Airlie <airlied@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       stephane.marchesin@gmail.com, madman2003@gmail.com,
       xavier.bestel@free.fr, airlied@linux.ie, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 7:34 PM, David Miller <davem@davemloft.net> wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 11 Dec 2009 09:18:43 +0000
>
>> However the fundamental point stands. The only people who can sign it off
>> are the people who wrote it. Those are the rules. Red Hat didn't write the
>> code, Red Hat cannot sign it off however much you rant at them. You also
>> previously said you don't want to merge stuff when the authors don't want
>> it merged.
>
> I agree with a lot of what you say.
>
> However, one point remains is that we were told, by Dave Airlie, that
> they didn't want this code merged because the one person being paid to
> work on it "would be overwhelmed" if the code went upstream.
>
> I distinctly remember this being mentioned at the kernel summit.
>
> And you know what?  That kind of excuse pisses me off too :-)

Well the main thing was I wasn't mean to discuss possible legal issues
and still don't have permission, you know as well as I do once lawyers are
involved you have to keep out of things until they deal with them.

but yes it is a side effect of upstreaming this code that other
distros will start
to place time demands on people who Red Hat employ but we were
starting to see that anyways without upstreaming. It would be have
been really nice
if some of the distros would start to put their money behind what they
want to ship instead of rhetoric[1].

Dave.

[1] http://www.markshuttleworth.com/archives/95
