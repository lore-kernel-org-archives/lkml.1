Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYBFMaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYBFMaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762151AbYBFMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:30:00 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:44043 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760910AbYBFM37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:29:59 -0500
Message-ID: <47A9A823.8020902@cfl.rr.com>
Date: Wed, 06 Feb 2008 07:29:23 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Max Krasnyanskiy <maxk@qualcomm.com>
CC: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Jackson <pj@sgi.com>, Mark Hounschell <markh@compro.net>
Subject: Re: cpuisol: CPU isolation extensions (take 2)
References: <47A8E977.3040500@qualcomm.com>
In-Reply-To: <47A8E977.3040500@qualcomm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyanskiy wrote:

> With CPU isolation
> it's very easy to achieve single digit usec worst case and around 200
> nsec average response times on off-the-shelf
> multi- processor/core systems (vanilla kernel plus these patches) even
> under exteme system load. 

Hi Max, could you elaborate on what sort events your response times are
from?

Regards
Mark
