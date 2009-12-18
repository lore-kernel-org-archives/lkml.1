Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZLRA03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZLRA03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZLRA02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:26:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZLRA01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:26:27 -0500
Message-ID: <4B2ACC11.3020209@zytor.com>
Date: Thu, 17 Dec 2009 16:25:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk
References: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org> <tip-8c63450718ea62ee3a70bffde170b4d15fc72d3c@git.kernel.org> <4B2AC710.2090705@redhat.com> <4B2AC7C0.6040801@zytor.com> <4B2ACA46.90707@redhat.com>
In-Reply-To: <4B2ACA46.90707@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 04:18 PM, Masami Hiramatsu wrote:
>>
>> How about looking for the first argument that starts with a number?
> 
> Sure, that's also possible. :-)
> 

Could you send me a patch?

	-hpa

