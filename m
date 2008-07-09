Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYGITtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYGITtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYGITtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:49:07 -0400
Received: from gw.goop.org ([64.81.55.164]:48496 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbYGITtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:49:06 -0400
Message-ID: <4875161F.70104@goop.org>
Date: Wed, 09 Jul 2008 12:48:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org> <48751513.9050202@linux-foundation.org>
In-Reply-To: <48751513.9050202@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> We would be glad if you could contribute the patches to get rid of the pda.xxx references. I do not think that either Mike or I have the 32 bit expertise needed to do that step. We went as far as we could. The patches are touching all the points of interest so locating the lines to fix should be easy.
>   

Yes, I'd be happy to contribute.

    J
