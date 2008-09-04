Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYIDTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYIDTOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYIDTOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:14:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36060 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYIDTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:14:00 -0400
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: frame unwinder patches
From: Andi Kleen <andi@firstfloor.org>
References: <g9p3du$n95$1@ger.gmane.org>
Date: Thu, 04 Sep 2008 21:13:58 +0200
In-Reply-To: <g9p3du$n95$1@ger.gmane.org> (Bernd Schubert's message of "Thu, 04 Sep 2008 18:46:52 +0200")
Message-ID: <87tzcvvi4p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert <bs@q-leap.de> writes:

> Hello,
>
> up to 2.6.22 the -mm series had these nice frame unwinder patches, 
> which gave beautiful stack traces. Unfortunately these frame unwinder patches
> seem to have been dropped :(
>
> Anyone still maintaining updated patches?

The SUSE kernel rpm should have an uptodate set

(ftp.suse.com/pub/projects/kernel/HEAD ) 

I agree that they were much better than the current unwinder,
also they didn't require slowing down the kernel with 
frame pointers.

-Andi 
