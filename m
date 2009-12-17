Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbZLQFar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbZLQFar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZLQFap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:30:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZLQFam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:30:42 -0500
Message-ID: <4B29C02B.80707@zytor.com>
Date: Wed, 16 Dec 2009 21:22:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Roland Dreier <rdreier@cisco.com>, Andrew Isaacson <adi@vmware.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B299AB5.7020109@zytor.com> <ada7hsm6y3g.fsf@roland-alpha.cisco.com> <4B29BC90.9090204@zytor.com> <4B29BFF1.6090304@redhat.com>
In-Reply-To: <4B29BFF1.6090304@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 09:21 PM, Masami Hiramatsu wrote:
> 
> Hmm, it's complicated :(.  Peter, Roland, I don't want to be annoyed
> by those environmental variables. If my last suggestion is acceptable,
> could you do as below on your patch :)?
> 

See my posted patch - I think it is better.  We're going to have this
problem again, guaranteed, unless we do something like it anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

