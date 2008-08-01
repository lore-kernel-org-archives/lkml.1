Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYHATsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYHATsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHATsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:48:23 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:52713 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYHATsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:48:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=DEjA1OZ/PBfxonI193NN3bYwS03fCjQBb1b7ztW8mBPBWnVt3b1HQTEGpkk/t4tS65VxVQzWCYhmV6XRHl5m5NHKJzHveo4smTRxPboXo8D6m3Q+K/qZ+ARjLBCHzUT+;
Message-ID: <48936881.6030907@simon.arlott.org.uk>
Date: Fri, 01 Aug 2008 20:48:17 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       =?UTF-8?B?Sm9jaGVuIFZvw58=?= <jochen.voss@googlemail.com>
Subject: Re: [PATCH] A development process document, V2
References: <20080731111443.2179bf4c@bike.lwn.net>
In-Reply-To: <20080731111443.2179bf4c@bike.lwn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/08 18:14, Jonathan Corbet wrote:
> +4.1: PITFALLS
> +
> +Coding style
> +
> +The kernel has long had a standard coding style, described in
> +Documentation/CodingStyle.  For much of that time, the policies described
> +in that file were taken as being, at most, advisory.  As a result, there is
> +a substantial amount of code in the kernel which does not meed the coding

meed -> meet

-- 
Simon Arlott
