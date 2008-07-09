Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYGITI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYGITI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYGITIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:08:20 -0400
Received: from gw.goop.org ([64.81.55.164]:60128 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYGITIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:08:19 -0400
Message-ID: <48750C94.70903@goop.org>
Date: Wed, 09 Jul 2008 12:08:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FAB2.5080401@goop.org> <4875000A.3060004@sgi.com> <48750202.3060603@goop.org> <4875041C.60206@sgi.com>
In-Reply-To: <4875041C.60206@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> One more approach... ;-)  Once the pda and percpu vars are in the same
> area, then could the pda be used for both 32 and 64...?
>   

The i386 code works quite reliably thanks ;)

    J
