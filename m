Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZIVXHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZIVXHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZIVXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:07:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:55318 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZIVXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=shsNqBwAZHNyaAsmv4WPeN8+X2EGwpf4nmVg2Sngq36jYr91mv66sqXz/3AFtv4tOd
         Pdq+tk8kThfouCxPzhZbNPeFraolIm7UM/pue8z8p2CUi6aa3SWuZiPloXT2+YyLl2OK
         WWR09zkEwXiG75lXEpbr14hFXU6mwPXvd/caY=
MIME-Version: 1.0
In-Reply-To: <200909221853.40148.elendil@planet.nl>
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
	 <200909201509.14794.elendil@planet.nl>
	 <31cb94fa0909220743w6c512075ve69ec292b37a079a@mail.gmail.com>
	 <200909221853.40148.elendil@planet.nl>
Date: Wed, 23 Sep 2009 07:07:08 +0800
Message-ID: <31cb94fa0909221607t67cd9477w525140509e4f232e@mail.gmail.com>
Subject: Re: PATCH: ARCH in builddeb
From: Wei Chong Tan <weichong78@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

> I don't think we should lose correct automatic detection for the sake of
> fixing your use case.
>
I agree, it is actually not such a big deal for my case.  I just
thought that if it can be fix once and for all, correctly for all
architecture and build, then it would make others (including myself)
less confused when first attempt it.

> I would suggest asking for advice on the debian-devel mailing list or,
> maybe even better, from the dpkg maintainers.
>
Let me try to ask around debian-devel then.

Regards,
Wei Chong.
