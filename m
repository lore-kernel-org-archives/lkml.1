Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbYF3QEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbYF3QEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYF3QEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:04:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:10820 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbYF3QEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hqHmr9EcOl3gBLMtNHrv9AXGGAitYLQMvltojIMgPJybOrqceBmTYGSSEEMba/dgEA
         LGu/oJNVgelBJVRsjdPszVBB3wQNMN7hqsmdP8jh8bUVoURzGeHCRAPVadxGwSBY9eQu
         NSlxUv2iQ6tG2G8YCf0MzZl6at7DVxJXY7WAE=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10861] 2.6.26-rc4-git2 - long pause during boot
Date: Mon, 30 Jun 2008 16:01:59 +0000
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Hannes Reinecke" <hare@suse.de>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik> <X8mbwW6K81I.A.BRF.E89ZIB@albercik>
In-Reply-To: <X8mbwW6K81I.A.BRF.E89ZIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301601.59199.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael

On Sunday 29 June 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>

As far as I'm concerned, the entry can be closed.. As I've said before, the 
patch did have a bad effect on existing user space, but, as Kay pointed out, 
there's no getting away from the fact that the rule in Slackware rules 
distributed with udev is a bad rule. the Slackware distribution does not 
include that rule in its udev rules.

I assume Kay will fix it in the udev package.

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
> Subject		: 2.6.26-rc4-git2 - long pause during boot
> Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2008-06-01 4:15 (29 days old)
> References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4

Thanks,

Chris

-- 
Beauty is in the eye of the beerholder.
