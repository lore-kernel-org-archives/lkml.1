Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZLJAwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZLJAwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZLJAwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:52:12 -0500
Received: from claw.goop.org ([74.207.240.146]:50995 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZLJAwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:52:11 -0500
Message-ID: <4B20463F.8050805@goop.org>
Date: Wed, 09 Dec 2009 16:52:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] x86: Merge pt_regs using syscalls
References: <1260403316-5679-1-git-send-email-brgerst@gmail.com> <4B204521.7030204@zytor.com>
In-Reply-To: <4B204521.7030204@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/09 16:47, H. Peter Anvin wrote:
> I have applied this series to tip:x86/asm with the addition of avoiding
> the extra pipeline serialization; assuming it doesn't break anything we
> can consider if we can push it for .33.  I really like the series,
> though; it is very clean and does the right thing.

Yep, agreed.

     J

