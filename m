Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZERI4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZERI4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZERI4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:56:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:18445 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZERI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GDb8ODO7qdAHci6bHOubm8DKPnESl0YBKGPld2UI8OGTmaFTdumcOvscQD4OHmtYyo
         xRiNViZem/g1GudDzox5F2tPvDAShe8hFv4uoqkqUYrgMYdH6jIXja2qq5X5yuyoB70P
         BsxK6mDJEvgrVFRJzTISDANjhq3Kbo5BJXNV8=
Message-ID: <4A1122A7.2010801@gmail.com>
Date: Mon, 18 May 2009 10:56:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: linux-kbuild@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Kconfig: fix problem in HID menu
References: <20090517175617.81323cc1.krzysztof.h1@wp.pl>	<4A111A85.6030508@gmail.com> <20090518104930.b9eb9936.krzysztof.h1@wp.pl>
In-Reply-To: <20090518104930.b9eb9936.krzysztof.h1@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2009 10:49 AM, Krzysztof Helt wrote:
> I see now. I was little surprised by this.

There was a thread where we decided to do that this way. I can't find it
now, I didn't give the searching much time though.
