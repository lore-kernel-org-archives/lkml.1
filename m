Return-Path: <linux-kernel-owner+w=401wt.eu-S1764086AbXGLPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764086AbXGLPCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXGLPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:02:12 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:43839 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbXGLPCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WCcdo4wqtkFS7+EAgOv1i7vTUNIJCMUE8n2U4gWYNwlMav+rYhv+LSYjdps+XApLkLqKXPerc3t90nsoio/VlJxL7+xK8Gp4IrBIMeQOEUO3ODRlUqOlQgGCzRklgFlGVWipjG1v0LohIqF/hXlx/fN+FjHWowE0W5dQhXm7GyY=
Message-ID: <f56c1ba00707120802g1e9032f9l96efd1a3b4a1f71a@mail.gmail.com>
Date: Thu, 12 Jul 2007 11:02:09 -0400
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel Story
In-Reply-To: <20070712143929.GA8147@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <b07b02c50707120627se95d62dybc70ef80efdbf24@mail.gmail.com>
	 <469635F4.9010409@mandic.com.br>
	 <20070712143929.GA8147@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/12, thinkinnight@gmail.com <thinkinnight@gmail.com>:
> On Thu, Jul 12, 2007 at 11:08:52AM -0300, Renato S. Yamane wrote:
> > Vijayakumar Subburaj escreveu:
> > >My first mail to lkml.
> >
> > Welcome :-)
> >
> > >I would like to know what happened to linux kernel from its 1.0.
> >
> > From 1.0 to 2.6.22.1?
> > Wowwwwwwwwwww
> >
> > I think that you can read all changelogs available in www.kernel.org. In
> > 2 years you finish read 2.4 and 2.6 series :-)
> >
> > Are you try <http://kernelnewbies.org/LinuxChanges>?
> >
>   I think this is a good idea to know all the changes!
>
> > Regards,
> > Renato
> > -

If you have to study some given sub-system, why not, you might have to
look at how this evolved from years to years, that must already be a
huge work from 2.0 to now for any single part of the kernel.
But seriously, if it's already virtually impossible to get a real
picture of the overall kernels, trying to figure out all changes from
1.0 to now, for all subsystems sounds a little illusory. Moreover they
might have just been all rewritten several times since.

But perhaps what Vijayakumar was looking for is more the different
feature that were added within the curse of years (eg : SMP) ?

Regards,
Cédric
