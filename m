Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZIBT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZIBT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZIBT6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:58:15 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40110 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZIBT6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oqtZG3280Um4zJ76oqOzMxH08x6Qe5qh5+Sybt09J5ENVuKwyMQFqBHbAODx2ss3Ag
         sarM3uK1vmF11Fnds9HjRPifYPx3V3cC2uWPDwNfAJuUSofz0oizY0UrYy+nrX3GMVeS
         AHuvgmNZ+FJwfjgP6Ek/TDzr+icM9JPOElDvM=
MIME-Version: 1.0
In-Reply-To: <20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 3 Sep 2009 01:28:17 +0530
X-Google-Sender-Auth: e2684d6cc125d3f8
Message-ID: <661de9470909021258j7fcc71fcv27d284738d1e37e3@mail.gmail.com>
Subject: Re: [mmotm][experimental][PATCH] coalescing charge
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 2:59 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I'm sorry that I'll be absent tomorrow. This is dump of current code.
> IMHO, this version is enough simple.
>
> My next target is css's refcnt per page. I think we never need it...

Is this against 27th August 2009 mmotm?

Balbir Singh
