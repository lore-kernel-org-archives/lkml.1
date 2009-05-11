Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZEKVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZEKVw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZEKVwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:52:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:11307 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZEKVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UaE7+EGxnBpGXcKObszS4tk8cENrzftifAxAGb7Un8O5wkyJ/KZPejaJlwk2Y3ck3/
         3hpEbcTb167YgPUGxWkTPn4or3jHkMxAJ0QGIEb7qK631EaVJOImpdZkeu8VKxTJp0l6
         DoAGGbE2/NIF9GlEoRXdYrZupZp6SxfWTZuT0=
Message-ID: <4A089DFD.8060609@gmail.com>
Date: Mon, 11 May 2009 23:51:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ferenc Wagner <wferi@niif.hu>,
       Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH 1/3] Char/serial: refactor ASYNC_ flags
References: <1242049860-29501-1-git-send-email-jirislaby@gmail.com> <20090511185727.2a5bd4cb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090511185727.2a5bd4cb@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2009 07:57 PM, Alan Cox wrote:
> Series all applied

Thanks.

Ferenc, could you apply patches 1 and 2 and confirm that it fixes your
problem?
