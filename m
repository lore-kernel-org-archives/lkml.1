Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbXEEQLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbXEEQLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXEEQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:11:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:29040 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbXEEQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=d4gCmKXZ8qdw36NnSTbm+SEwKYY/g8XfdR7wMQ+e2q79PwIxS1abNig8rb5GCBTPZnGioHyQ42A3XSk2VAp1Aapfd043Mdr4wdRVQLPoKFuh95e7J5NQhfkuOyrHvS/lDKNgD4IvYocPWB1TcLaNKQeyR4LV5B5ugi+mKUlENew=
Message-ID: <463CAC50.2050402@googlemail.com>
Date: Sat, 05 May 2007 18:09:52 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
>
>   

I get a lot ' warning: 'warn_unused_result' attribute ignored ' from 
mutex.h:128

I've uploaded full build-log , config and ver_linux there -> 
http://crazy.dev.frugalware.org/2.6.21-mm1/


Gabriel
