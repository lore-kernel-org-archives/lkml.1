Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYHRVfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYHRVfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYHRVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:35:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:37821 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYHRVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IArEIIuFVUazTLrgPiSjUCI4mEg6z+iOroc6bDnnAJJl9kqMl673VDmW3m78Pf2pDq
         jBe+WgIfQzdriwe/uheITmlfcPka32UNmZEwkUd6ubHrfZeMbJwfNYKQB+9yWEz4C5k/
         wrCrvdtlteRnlKpYDBv07tNZYl2odLDspyJUU=
Message-ID: <86802c440808181434q2c3b20fcs197c52c51717e782@mail.gmail.com>
Date: Mon, 18 Aug 2008 14:34:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: [linux-pm] forcedeth 10de:0373 doesn't work on resume
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>, jgarzik@redhat.com,
       netdev@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, ranma+kernel@tdiedrich.de
In-Reply-To: <48A9E8B3.4040800@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4898AA28.8000507@simon.arlott.org.uk>
	 <20080818134814.136105c9.akpm@linux-foundation.org>
	 <200808182313.10235.rjw@sisk.pl>
	 <48A9E8B3.4040800@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 2:25 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 18/08/08 22:13, Rafael J. Wysocki wrote:
>
>>> Is it still broken in current kernels?
>>
>> It probably is.
>
> If I have MSI enabled, it still doesn't work.

same problem with nv_shutdown about setting it to D3Hot?

YH
