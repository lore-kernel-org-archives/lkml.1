Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZG2LLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZG2LLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbZG2LLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:11:14 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:54739 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZG2LLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jJYeppHl0G1ek0S796Csvfzm6+2KJdWnHUOzgsnbLUb0EdzwBoM40DiQTQgTz2nSEN
         nFWeaggWQthE507BmSz9+lRpSD8F/TsjlOYI83bxjhKi3Pvj9lKJt/twZAbZcbXpd21m
         EZe8lM2/TtAMKxpnWjpFU0M93OcVWwCkmtjhQ=
Message-ID: <4A702E51.9010504@gmail.com>
Date: Wed, 29 Jul 2009 13:11:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cyclades: allow overriding ISA defaults also when the
 driver is built-in
References: <200907290023.48870.bzolnier@gmail.com>
In-Reply-To: <200907290023.48870.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 12:23 AM, Bartlomiej Zolnierkiewicz wrote:
> Subject: [PATCH] cyclades: allow overriding ISA defaults also when the driver is built-in

Thanks, I rebased it on the top of Roel Kluin's fix.
