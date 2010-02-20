Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0BTBQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:16:47 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:35864 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0BTBQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R3mmsto5lKNRqrSzm1nxd4/Q6s3lpawNEG+xXsQHs5KnEsuDQncHvtPwY2XWccl55g
         IzL6xMwCsbs1HTGOlJ/xE1Hv6Adkfe8T8cpUVREPTYiJ3CR3LAJj3a1zptNpYlgkwudk
         ifsTDm8VUOYxf8KlTtCOVQEaXjrLnMz9TWv7g=
Message-ID: <4B7F37FA.2050608@gmail.com>
Date: Fri, 19 Feb 2010 19:16:42 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org, megaraidlinux@lsi.com,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [BUG]  smartd crashing recent 2.6.32 kernel
References: <1151832579@web.de>
In-Reply-To: <1151832579@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding CCs. Looks like a megaraid_mbox bug..

On 02/19/2010 04:13 PM, devzero@web.de wrote:
> as time goes by, no real attempt or progress has been made to fix bug #15171. ( http://bugzilla.kernel.org/show_bug.cgi?id=15171 )
>
> when smartd starts, the kernel crashes with this trace:
> https://bugzillafiles.novell.org/attachment.cgi?id=338427
>
> the machine with this problem will be go into production very soon, so if anybody want`s to help on fixing this - we have a few days left......
> ______________________________________________________
> GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
> Jetzt freischalten unter http://movieflat.web.de
>

