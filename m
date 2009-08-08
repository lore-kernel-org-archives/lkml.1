Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbZHHDD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbZHHDD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 23:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbZHHDD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 23:03:57 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52309 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbZHHDD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 23:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=luijpD7HRc8j+OgMD7vr6pPgAO5Tfwm63NMuriz101qeV0RFVamFVSGhqZqggm0b87
         Acatkvu0QmmqVAOw4zKpzjWVLM/YtgFgOkgmsn36mqOxLfezO6S4f0oCyPjoTDA6zzEI
         d8dmJ7DOUXFuOf3mnAjidpdPXIiv+UOqq26v8=
MIME-Version: 1.0
In-Reply-To: <20090802081612.GA14646@darkstar>
References: <20090802081612.GA14646@darkstar>
Date: Sat, 8 Aug 2009 11:03:56 +0800
Message-ID: <a8e1da0908072003j1267ec89p366dc62c271663b7@mail.gmail.com>
Subject: Re: touchpad stuck sometimes
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 4:16 PM, Dave Young<hidave.darkstar@gmail.com> wrote:
> Hi,
>
> My touchpad sometimes will stuck for a while, and then it will be ok.
>
> I can see kernel message like this:
>
> [ 1293.426227] psmouse.c: GlidePoint at isa0060/serio1/input0 lost synchronization, throwing 2 bytes away.
> [ 1293.969357] psmouse.c: resync failed, issuing reconnect request
>
> Hardware is dell e5400, kernel version: 2.6.31-rc5
>
> --
> Regards
> dave
>

Add Dmitry to cc list

-- 
Regards
dave
