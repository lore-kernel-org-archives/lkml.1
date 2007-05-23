Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbXEWPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbXEWPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXEWPZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:25:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29227 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbXEWPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AkIqMg50o+SmbrsGG+Ttc1zIOYFqvW073isd+pjoIwX67EEDxsSM1ibFOfuQ2qR8zIcde2+BdaN9M2WLBCh6g5ryxTAbMOEOHu6BWGHnvYhV+1JU0gVDtl2L3ohsr+9g5ao/Kxg080Hyi3m70y9aZ6YeJH8IAUgvlkdwTYLYync=
Message-ID: <d9b9d95f0705230825y24496ba3i4340d69ad78028cd@mail.gmail.com>
Date: Wed, 23 May 2007 16:25:14 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [PATCH] joydev.c automatic re-calibration
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705231644520.27422@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
	 <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
	 <d120d5000705230737s40d92df7m91a7b574e3a9c0d1@mail.gmail.com>
	 <Pine.LNX.4.64.0705231644520.27422@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/07, Jiri Kosina <jikos@jikos.cz> wrote:
> I have asked Renato to provide HID debugging output a few days ago - see
> http://lkml.org/lkml/2007/5/21/201 - but that was without reply.

Sorry, didn't get the email.


> Renato, do you think you could try this, so that we can understand better
> if we can't put a HID quirk to normalize the values on HID-level somehow?

Good idea. I've put some debugging (but posted in the wrong list)
about the values my joystick is reporting. Will turn on HID debugging
and post the results.

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
