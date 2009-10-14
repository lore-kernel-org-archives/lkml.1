Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbZJNS5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbZJNS5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760481AbZJNS5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:57:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:46242 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbZJNS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=oboIfuwv3s3BfHfpikQTi/lh4Q2Dn3tah2OT5QVRnE/Ixmt/vxb77VU/zhHnhcUtRZ
         96kKwCrw9C/6HKjvTOwhTiGC9skuUOWJsm6fW6ZKbC+kTOVP6gbLRLeeMMst8cFfCu8E
         zrjr0kZEZEWyYoLyOwsJWG0FhBqsCd385Bh8A=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Wed, 14 Oct 2009 20:56:17 +0200
User-Agent: KMail/1.9.10
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <20091014164710.GF2890@tuxdriver.com> <200910141933.09374.bzolnier@gmail.com>
In-Reply-To: <200910141933.09374.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910142056.18295.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > On Wed, Oct 14, 2009 at 05:28:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > > I don't have a have a problem with it personally as long as people accept
> > > the competition..  but instead of working on _their_ projects they go around
> > > screaming at everybody who does not want to spin inside the great process
> > > designed by them..
> > 
> > Please whine somewhere else.  You have the freedom to work in
> > drivers/staging all you want.  You do not have the power to force us to
> > like it -- especially in a case where you are diverting attention from
> > the community-maintained drivers instead of cooperating with them.
> 
> Cooperating you say.
> 
> rtl8187 -- before starting the work on rtl8187se I've pinged the maintainer
> to coordinate the effort and hear his opinion on how to progress..
> 
> I've never heard back.
> 
> rt2x00 -- I know that people have datasheets for some chipsets but I've
> never heard "How can we help you" etc. thing.

The rt2x00 members received the specsheets under the condition that we didn't
distribute them further.

So everybody which requested the datasheets from the rt2x00 project were presented
with a choice:
1) We provide the email address of the Ralink contact person which can device if you
can get the specsheet or not (possibly under NDA, but this isn't always the case).
2) Specific questions about the registers can be asked and we give all the information we
know from our work on the rt2x00 project plus additional information from the specsheet.
Seeing that the specsheet doesn't always match reality, you get the better answers with
this option, but some people just hate it when they need to ask other people for stuff.

> All I've ever heard was _lies_ about current state of affairs or that
> my work is in the way.

I have encounterd your email address in only 2 rt2x00 related discussions
(yes I have checked my entire email archive). Both cases were regarding
staging vs rt2x00.

So far I never said rt2800usb or rt2800pci were high quality, I never said they were in a good
shape. On the other hand, I often talked about the problems with the drivers, requesting help
to improve the drivers, etc etc.

So are you basing this "I am hearing lies" about a random person talking on the street
about rt2x00 which is telling the lie?

Ivo
