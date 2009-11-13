Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZKMTAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZKMTAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbZKMTAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:00:05 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:40194 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZKMTAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=HH2qiSFGz4G+6fJBh4KylHvX+Js6bjhxcQNnc2HaUfF66/wx0XRVHWQG8v8DzMW9k3
         ZCSMckOXbUG4twgCSbY7IO4z8+Z1em0ykCNz8b8eJodKkD0V/zK8iYwuC4/7MhAK8PEf
         qBeI6SnIiSqAUDONs1ANSTR/g906QLCtUv7DE=
MIME-Version: 1.0
In-Reply-To: <a44ae5cd0911131056i242ca15dmceff81466b897c9e@mail.gmail.com>
References: <a44ae5cd0911112058s52d59f5dy707633fce9eb3816@mail.gmail.com> 
	<a44ae5cd0911131056i242ca15dmceff81466b897c9e@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 10:59:49 -0800
Message-ID: <43e72e890911131059xde0494laa22684f3b8a65b4@mail.gmail.com>
Subject: Re: [ath9k-devel] 2.6.32-rc6-git4 -- BUG kmalloc-8192: Poison 
	overwritten - INFO: Allocated in ath_rxbuf_alloc+0x1c/0x70 [ath] age=526999 
	cpu=1 pid=1275
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 10:56 AM, Miles Lane <miles.lane@gmail.com> wrote:
> I just got this again in 2.6.32-rc7.

How can you trigger it?

  Luis
