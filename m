Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZKNRAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZKNRAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 12:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZKNRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 12:00:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:11359 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZKNRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 12:00:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Bq52PXK6vQVamZEb32+4Lac21Q0fz9HWgPIkPOjVyhfzsGko8Lj1PSkdDtw6FzrpLQ
         PUChJY2VPtFMJkP1ixFOxZxWdSyjfPY1tIGi1cSzhk7iQ7Cw99T55lFNJNT+QF9TW7dr
         H+RVgDM0yUSogh/aRtwSpxdTVJgP6tC3T0emE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 17:59:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Jonathan Corbet <corbet@lwn.net>
References: <4AFCC0D4.9020708@gmail.com> <200911140208.29888.bzolnier@gmail.com> <20091114160438.6ed0dc75@lxorguk.ukuu.org.uk>
In-Reply-To: <20091114160438.6ed0dc75@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911141759.22702.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009 17:04:38 Alan Cox wrote:
> > > As you quoted the old PDC202xx driver does not work on my test hardware.
> > > The libata one does. That is what is popularly known as a "fact". I'm not
> > 
> > You want facts?  Here we go:
> 
> So you spent the day searching bugzillas.. congratulations. Btw you

Lol, how come's that you know better then me what I do? :)

[ I didn't spend a single minute on it, some good people pinged me for help
  and gave me bugzilla numbers.. ]

-- 
Bartlomiej Zolnierkiewicz
