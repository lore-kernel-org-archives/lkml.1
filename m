Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZLCWau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZLCWau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZLCWat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:30:49 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:41768 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZLCWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:30:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GklOfCfhoQPSkZtcOcRKLaMmjIaT5ZHB0QOxyKBPvvY9mnbAIyUW8w7fAQkD6cZWUD
         CaBCFlSGhtYXJVdAk0EPkS6eE+cFiFw3FNFC892puV71xqtwxbpjr6GJIQL8nbGhm4Fl
         HVz8WRLF3CmIegRF9LcF9ZpWrIlHxHwDUQfpo=
Message-ID: <4B183C1A.3080609@garzik.org>
Date: Thu, 03 Dec 2009 17:30:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032306.52022.bzolnier@gmail.com> <4B18376B.3080404@garzik.org> <200912032323.39846.bzolnier@gmail.com>
In-Reply-To: <200912032323.39846.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 05:23 PM, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 03 December 2009 11:10:51 pm Jeff Garzik wrote:
>> Is it good kernel practice to intermingle cosmetic changes with
>> functional ones, in the same code lines?  Also, no.
>
> I prefer using common sense over black-and-white rules.
>
> If patch is a _really_ tiny one (<  20 LOC changed) it sometimes makes
> sense to save the time on handling separate patches.

This is open source -- you have to consider the time saved by reviewers too.

But I doubt you have saved time on all your motivated commit searches, so...

	Jeff



