Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXJKFJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXJKFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXJKFJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:09:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:34975 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbXJKFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U4kUOc5PJLyNwN7+kzee2larPsACtv5en/Jv3v2KP3EZgBIF0GR0CaiMDC4CxOgnDoaiyfRyp1gCKmzLsZ4AgyMwPR+8muKBctGdehbmddYtDnn0wFHJjhucWktBCCehka7u7TCRpO79asT1J79v7WR7KlcecU8b56BNLyETXrE=
Message-ID: <d9def9db0710102209g1cc905a7w5565f1ecda720ea4@mail.gmail.com>
Date: Thu, 11 Oct 2007 07:09:47 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071010163625.b4b438ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <20071010163625.b4b438ec.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 11 Oct 2007 01:00:39 +0200
> "Markus Rechberger" <mrechberger@gmail.com> wrote:
>
> Please don't send 900 line emails to which you have added only an additional
> paragraph.
>
> > >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> > >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> > >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> >
> > not accepted
>
> Until your attempt to get the userspace-driver work merged into the kernel
> is successful (and from my reading of last month's discussion it is nowhere
> near that), we should continue to maintain the present driver.
>
> If you choose to not participate in that maintenance then others will need
> to do their best in this regard.
>
> What we should not and will not do is to permit the current driver to be
> held hostage to your attempt to force a controversial and apparently
> unwelcome change into the tree.
>

It makes no sense to keep the kernel driver uptodate, it would make
more sense to support the latest driver (which some people are
supporting).
I just had a look at the driver downloads it makes around 600
downloads for september for this driver. If someone's interested in
those stats I can give access to it privatly.
The current option for people who own such a device is to take the
driver from mcentral.de.

Markus
