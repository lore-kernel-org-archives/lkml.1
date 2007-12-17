Return-Path: <linux-kernel-owner+w=401wt.eu-S935167AbXLQWKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167AbXLQWKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXLQWKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:10:46 -0500
Received: from saeurebad.de ([85.214.36.134]:58042 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbXLQWKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:10:45 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Stephen.Clark@seclark.us
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cpuinfo_cur_freq always max
References: <4766B724.7090106@seclark.us> <x7k5ndj9ki.fsf@saeurebad.de>
	<4766ECDB.1040203@seclark.us>
Date: Mon, 17 Dec 2007 23:09:31 +0100
In-Reply-To: <4766ECDB.1040203@seclark.us> (Stephen Clark's message of "Mon,
	17 Dec 2007 16:40:43 -0500")
Message-ID: <x7fxy1j7ms.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stephen Clark <Stephen.Clark@seclark.us> writes:

>>Which governor are you using?  ondemand?
> Not sure - but the only thing that is changed is the kernel - if I go
> back to 2.6.23.1 it works correctly.

Have a look at /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

	Hannes

PS: Steve, please keep the list in CC.
