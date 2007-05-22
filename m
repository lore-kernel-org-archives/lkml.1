Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbXEVAIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbXEVAIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbXEVAIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:08:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:7852 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbXEVAIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NjN5pCwwJhHm+U0fYQ1RM1Xp6OjZeT/wuqCRJN32IsLuarFyJRL+P1kCtRw/q+2rGtxuoroRVkVwQFPpiXjyAiIgvO5xwym67xut8i7gdOWvNasU4pf4rKjh0MFe95WV2lxE0drUn14rXITmjE2Hs3NrBEZ/pgsCMhfUagh30XQ=
Message-ID: <9e4733910705211708p5a79fb9eg37a97a53d7ba0fce@mail.gmail.com>
Date: Mon, 21 May 2007 20:08:00 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "Luc Verhaegen" <libv@skynet.be>
In-Reply-To: <46522A3C.4090604@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
	 <21d7e9970705211047n2328f970ref96ea85856f3ba8@mail.gmail.com>
	 <9e4733910705211104u143e7abercccc4f351441343e@mail.gmail.com>
	 <21d7e9970705211144j219fa8f5n3e5ceab90f7d3f0b@mail.gmail.com>
	 <9e4733910705211210h7b993da8g67d31a010eb4c3f3@mail.gmail.com>
	 <46522A3C.4090604@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jon Smirl wrote:
> > There is a significant group of Linux users who want to be able to
> > login separate users to each screen/head/crtc/output device. These
> > people are concentrated in the third world and don't show up at OLS to
> > argue their case.
> >
> > There is another group that wants Unicode consoles. The people I
> > talked to were from India and Japan.
>
> If these "significant groups" do not bubble up to the surface, nothing
> we can do about that.

You need to take into account that these features have been asked
about for years and we didn't respond. People interested in this have
turned to other solutions.

James Simmons maintained a multi-seat version of the 2.4 kernel for
years that had many happy users. I don't know the details about why it
never got merged. I believe two companies built special multi-head
video hardware for it (Appian and Matrox? it has been a while).

People needing Unicode console support can't speak English. How can
they complain on LKML? Linux is an OS for the world, we really should
make Unicode console work.

-- 
Jon Smirl
jonsmirl@gmail.com
