Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0BNS7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:59:11 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:60339 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0BNS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QApLDHRED515teA1imHpgHvmc9z4aOTo5bNtjkUWjSTgeqRHB+tGo6EIi+gr/Yix3g
         BrPRG5ZE84ZeuswN67p0IGLW5hIDIL9PYitqj1K/k48Xm1ird+K8s6H9XOq8RayfXtSb
         wFBqX4+Nb9XDO3vrpSYNMHcgX7SdDHq5fAZuw=
MIME-Version: 1.0
In-Reply-To: <20100214165528.GA25624@srcf.ucam.org>
References: <1266144897-2681-1-git-send-email-erik.andren@gmail.com>
	 <20100214165528.GA25624@srcf.ucam.org>
Date: Sun, 14 Feb 2010 19:59:06 +0100
Message-ID: <62e5edd41002141059k5e06fc5o91b06e389d9609e3@mail.gmail.com>
Subject: Re: [PATCH 1/1] platform/x86/dell-laptop: Add another Dell laptop to 
	the DMI whitelist
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/14 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Sun, Feb 14, 2010 at 11:54:57AM +0100, Erik Andren wrote:
>> The Latitude C640 has another variation of dell in its DMI vendor entry.
>> Add it to the whitelist in order to enjoy the sweet fruits of software backlight toggling.
>
> Thanks, picked up for .34.
>

Darn, I forgot to add another module alias.
Shall I respin the whole patch or create another one depending on the old one?

Best regards,
Erik

> --
> Matthew Garrett | mjg59@srcf.ucam.org
>
