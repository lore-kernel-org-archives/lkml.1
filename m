Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYBGSzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYBGSzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYBGSzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:55:22 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:33164 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYBGSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:55:20 -0500
X-IronPort-AV: E=Sophos;i="4.25,316,1199682000"; 
   d="scan'208";a="48104147"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: linux-usb@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Gadget driver repository?
Date: Thu, 7 Feb 2008 13:56:36 -0500
User-Agent: KMail/1.9.5
References: <200802051456.07442.rgetz@blackfin.uclinux.org>
In-Reply-To: <200802051456.07442.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071356.36380.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Feb 2008 18:55:09.0902 (UTC) FILETIME=[F669C6E0:01C869BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 5 Feb 2008 14:56, Robin Getz pondered:
> I was wondering where (or if) there were any non-mainlined gadget
> drivers that 
> were kept anywhere?
> 
> According to (2005)
> http://www.linux-usb.org/gadget/
> 
> >  Other controller and gadget drivers are in development, but are
> >  unreleased or not published here. Examples that have seen some 
> >  degree of light include:
> >
> >     * HID driver (userspace, with gadgetfs),
> >     * "MTP" (Media Transfer Protocol, PTP++) driver (userspace, 
> >        with gadgetfs), * two different printer class drivers (used
> >        in various products),
> >     * audio class driver (very experimental). 
> >     * video class driver (very experimental).
> 
> I'm actually looking for the gadget side of HID and Audio and anyone has
> any pointers?

OK - so that got nothing.


Is anyone interested in helping develop them, so a reference open source 
implementation exists?
