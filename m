Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZKNQC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZKNQC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 11:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZKNQC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 11:02:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58682 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753691AbZKNQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 11:02:55 -0500
Date: Sat, 14 Nov 2009 16:04:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Message-ID: <20091114160438.6ed0dc75@lxorguk.ukuu.org.uk>
In-Reply-To: <200911140208.29888.bzolnier@gmail.com>
References: <4AFCC0D4.9020708@gmail.com>
	<200911140046.29450.bzolnier@gmail.com>
	<20091114001510.2dd0ab5d@lxorguk.ukuu.org.uk>
	<200911140208.29888.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As you quoted the old PDC202xx driver does not work on my test hardware.
> > The libata one does. That is what is popularly known as a "fact". I'm not
> 
> You want facts?  Here we go:

So you spent the day searching bugzillas.. congratulations. Btw you
missed one. I have a total of four reports I know about.

> I regret this work -- because of it I share the blame for the new driver
> and keep getting complains about it..

Amazing.. I don't.

I look forward to receiving patches from Red Hat, SuSE or Ubuntu.

Alan
