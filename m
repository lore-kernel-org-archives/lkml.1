Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbXEKMZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbXEKMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbXEKMZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:25:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:1419 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbXEKMZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RgXleKEYu1p7nxmnbNpYuobfiA0ugIFS6jbfSglHnVgYlZ2nyhDAIncMZrDQhsEsEorB8BxayVJQKmDEAeRU+voQAbAPfCZbnnfBJgaItnAI3Fq1BrC0m/bvimgVaQdK0XwhM6psGh47CQ7K2OxZpkScaOEghPzW1DxzWZmKnV0=
Message-ID: <9b53a56d0705110525o336eb0b8sb963d95608c94b9@mail.gmail.com>
Date: Fri, 11 May 2007 08:25:13 -0400
From: "Chris Smith" <smitty1elkml@gmail.com>
To: "Arne Georg Gleditsch" <argggh@dolphinics.no>
Subject: Re: [RFC] - LXR on kernel.org ? was: Re: What tools to use?
Cc: devzero@web.de, linux-kernel@vger.kernel.org, jcm@redhat.com
In-Reply-To: <873b23ivr2.fsf@pelargir.dolphinics.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1783741195@web.de> <873b23ivr2.fsf@pelargir.dolphinics.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2007 10:56:33 +0200, Arne Georg Gleditsch
<argggh@dolphinics.no> wrote:
> devzero@web.de writes:
> > I like lxr pretty much.  i`m not a programmer, but i often need some
> > information on "what`s the driver version of xyz in latest kernel" or
> > "was this or that feature/patch already being merged" or "i have this
> > line of code in kernel - how does it look in recent kernel , did it
> > change " ?
> >
> > over the years, i have downloaded tons of kernels for this, very much
> > waste of bandwidth and time - because whenever i need to take a look,
> > i have no recent kernel source around - so i need to download that big
> > thing and go trough that untar orgy. having recent
> > browsable/searchable and easy to find lxr`ed kernel-source online
> > would be really great
> >
> > i seldom find lxr for current kernels on the net, so i just wonder:
> > [..]
>
> I maintain the original LXR site at lxr.linux.no, which unfortunately
> tends to lag behind quite a bit.  This is partly due to lack of time
> to keep it current on my part, but also due to the fact that adding
> new kernels to the version running on lxr.linux.no is a bit more time
> and resource-consuming than it ought to be.  Better support for both
> incremental indexing and git-based repos is forthcoming, and I hope
> the situation will improve a bit with that.  I'll keep you posted.
>
> --
Now, if you merged the beauty of LXR with the wiki goodness of
kernelnewbies.org, and somehow kept it current <waves hands> that
could be cool.
--
Chris
