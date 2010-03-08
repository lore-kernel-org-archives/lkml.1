Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0CHVbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:31:24 -0500
Received: from server109b.appriver.com ([72.32.253.86]:3677 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755600Ab0CHVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:31:19 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G179 G180 G181 G182 G186 G187 G198 G285 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4B956D26.6080602@intcomgrp.com>
Date: Mon, 08 Mar 2010 16:33:26 -0500
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Chihau Chau <chihau@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: key: keyring: fix code style issues
References: <elPIC-7L6-15@gated-at.bofh.it> <4B954CCE.8080902@intcomgrp.com> <f5ca57691003081211g2dab077cv323138699ccd03b3@mail.gmail.com>
In-Reply-To: <f5ca57691003081211g2dab077cv323138699ccd03b3@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2010 21:33:26.0043 (UTC) FILETIME=[FC7FE6B0:01CABF06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/2010 3:11 PM, Chihau Chau wrote:
> Ok,
>
> And What about to include <linux/uaccess.h> instead <asm/uaccess.h> ?
>
> Thanks!
>
>   
<--snip-->

It looks like the main branch is moving toward using <linux/uaccess.h>
instead of the old <asm/uaccess.h> file; so, I'm okay with that.

James K.
