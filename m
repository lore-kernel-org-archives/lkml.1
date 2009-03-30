Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZC3Qts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZC3Qts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZC3QsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:48:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36147 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbZC3QsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:48:00 -0400
Date: Mon, 30 Mar 2009 12:47:02 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org
Subject: Re: Linux-2.6.29-git6 Compile Error
Message-ID: <20090330164702.GA6372@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
	linux-kernel@vger.kernel.org
References: <49D0D3DF.1050008@turknet.net.tr> <20090330143438.GA6736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330143438.GA6736@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 04:34:38PM +0200, Ingo Molnar wrote:
 > 
 > (Cc: added)

See 199785eac892a1fa1b71cc22bec58e8b156d9311
Steven picked up in this build failure _months_ ago in -next,
which caused me to regenerate the cpufreq tree so that the build failure
wouldn't get introduced to mainline.

Then the x86-merge comes along, and steamrollers over it.

Great job.

	Dave 

