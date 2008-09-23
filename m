Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYIWJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYIWJgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYIWJgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:36:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:10842 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYIWJgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FNRCcsMaCytc851k6rURzYlMW/aRACkyUN0KH8jELTcM8CZ0qNXuI69O9ohBLvtiuP
         c89QgCvAzvofa3BCdgVDsQwkuj7RRper3PbL87VcOjpWCxEZ9n0p0VTmpa4fJ6VRLDAt
         YeLWkA1uZvPFmmnB5vjffqNbS0sL5gMhZGX2U=
Message-ID: <ed7dcf450809230236v762e0aa3v8748c76a64121f0c@mail.gmail.com>
Date: Tue, 23 Sep 2008 11:36:06 +0200
From: "=?ISO-8859-1?Q?S=F8ren_Hauberg?=" <hauberg@gmail.com>
To: "Ondrej Zary" <linux@rainbow-software.org>
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200809231051.14016.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com>
	 <200809231051.14016.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/23 Ondrej Zary <linux@rainbow-software.org>:
> Calibration is a per-device thing. You can have more than one touchscreen (the
> swap_xy feature is also wrong, but better than nothing).

Yes, this is true. I'm going to claim (and I have no factual evidence
to back this claim, I'm just making it up) that almost all touchscreen
users only have one touchscreen. So, I'd rather have something that
works for most users, then the current situation. Is it optimal? No!
Is it practical? I believe so. Using your words, it's "better than
nothing".

Søren

>> Søren
>>
>> P.S. I'm not subscribed to the list so please keep me in the CC.
