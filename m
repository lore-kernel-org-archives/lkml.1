Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYHYEWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYHYEWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 00:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbYHYEWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 00:22:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:34395 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYHYEWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 00:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sXk2RZjrpJRFzOWOmbQRaQbX/2YH3r84yQVSPoscrZfEwPGLwHqBIdt9NJpp//xLNc
         KIC0nFsZ6vyIkC3E7euPEI1L8Brr9MVQ/R7ThETcLfl2sqiyNDIC3NpTIUeeWK49ZLi8
         +UHY/+kDmI4ztT/c2RJ0ef89cNhLDP2gK90xM=
Message-ID: <dd18b0c30808242122h5b6dfc15tf86622595bd46461@mail.gmail.com>
Date: Sun, 24 Aug 2008 21:22:45 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE:converting appletouch to usb autosuspend again...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've notice when letting the system rest for a few and then tapping the
touchpad I see this in dmesg:
appletouch: 17" model detected.
could this be suspend working?
As for appletouch surving suspend
I't seems to work i.g.
one tap, two tap, side scroll,
although with the latest git
and the latest update from sid(of xserver);
I'm not seeing these functions work....

-- 
Justin P. Mattock
