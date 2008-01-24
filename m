Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbYAXUob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbYAXUob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYAXUgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:36:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:43994 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbYAXUgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:36:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FgRh4xK66gT04txDpCTGCUciTq1njxrThwzqJbiNIVngaB5YDGF5Lk8ZkYsXBQ8pcS1/RXmnb9MYoK2T7gaH8G4mpqOf2Cxd0igHj6O647LdeLldXVdpNeJp+s1q32801YkDtOK//h/ZqXVmqrzITge3rHRkV6YKFL5Omo6qTlE=
From: Marcin Gil <marcin.gil@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Date: Thu, 24 Jan 2008 21:36:25 +0100
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200801232323.36187.marcin.gil@gmail.com> <4798A537.9000104@gmail.com> <m3abmvtah1.fsf@maximus.localdomain>
In-Reply-To: <m3abmvtah1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801242136.25554.marcin.gil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia czwartek 24 stycznia 2008, Krzysztof Halasa napisał:
> Marcin Gil <marcin.gil@gmail.com> writes:
> > +-----+-----+
> > mobo  hdd   dvd
> >
> > I think that cable select would take dvd as master and hdd as slave.
> > This was not preferable when hdd was my primary drive. I can try
> > cable-select now since I boot off new SATA drive.
>
> Is a master in the middle permitted by the specs at all?

I don't know. I had to do this because of the drive placement in the case.
DVD drive is high above HDD drive -- thus I had to place DVD on the end.

I'll switch to cable select in the moment and report back to you.

Thank you,
-Marcin Gil
