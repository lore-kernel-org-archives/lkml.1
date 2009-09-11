Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZIKRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZIKRsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZIKRsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:48:32 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:47658 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZIKRsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=QezZuhJJKDrxPchSE8Rp9Lp5ZaGtiBzbetDDw4iOqvMBvl0/gppbJYuFWg4Ueqa+7n
         48kbXUvPKcg8J/og2ILmougfodirB3xE8NzlWTVq0V2sBIfaw1X89cJ5FbbEIWVjUmSB
         jRmrpvj3i3jlQTRVxfesZIFiM2cpZx9qQ9eJ0=
Date: Fri, 11 Sep 2009 13:48:31 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] PM: Measure device suspend and resume times
Message-ID: <20090911174831.GA11467@ben-laptop>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
References: <200909100127.11252.rjw@sisk.pl>
 <200909100139.21954.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909100139.21954.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 01:39:21AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Measure and print the time of suspending and resuming all devices.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Do you have any rough numbers describing actual suspend/resume times
before and after this patch set?  Of what order of magnitude is the
improvement on standard x86 hardware? Just curious.

Thanks,

- Ben
