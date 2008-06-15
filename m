Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYFOGPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYFOGPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 02:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYFOGOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 02:14:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:3822 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYFOGOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 02:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=n0y+lpcTJIs4SqPeVX8JLfnqTUwPT1cLOLa4+vgxJGKWEx0dVOUIuS9puPJZFoDl4H
         eBzLOMEs9SnP+SyqJ32pc0DS6Vcp/G+agoZ4XBCX6LsxL26CQ18vHEcczPZKegVTbUfM
         4OKnhrh/IAYIhhuuTzM7hnrYhSlYxMN8fef7c=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Sun, 15 Jun 2008 06:12:17 +0000
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Hannes Reinecke" <hare@suse.de>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A.71D.HJDVIB@albercik>
In-Reply-To: <Jn7irxIunJK.A.71D.HJDVIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806150612.17215.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 June 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
> Subject		: 2.6.26-rc4-git2 - long pause during boot
> Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2008-06-01 4:15 (14 days old)
> References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4

Well, we know how to create (and to avoid) the problem. Since the original patch 
adversely affects existing user space, it could be argued that it is a 
regression, but I see that there is a counter argument that the udev rule that 
triggers the problem is quite simply a bad rule.

I'll leave to those more closely concerned that rule on that.

Thanks

Chris

-- 
Beauty is in the eye of the beerholder.
