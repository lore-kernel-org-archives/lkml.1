Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbXLQV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbXLQV3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181AbXLQV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:28:56 -0500
Received: from saeurebad.de ([85.214.36.134]:57482 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXLQV2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:28:53 -0500
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Stephen.Clark@seclark.us
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpuinfo_cur_freq always max
References: <4766B724.7090106@seclark.us>
Date: Mon, 17 Dec 2007 22:27:41 +0100
In-Reply-To: <4766B724.7090106@seclark.us> (Stephen Clark's message of "Mon,
	17 Dec 2007 12:51:32 -0500")
Message-ID: <x7k5ndj9ki.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Stephen Clark <Stephen.Clark@seclark.us> writes:

> But with 2.6.23.8-34.fc7
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
> is always the max cpu speed of 1826000.
>
> While cpuinfo_cur_freq is the max 1826000 /proc/cpuinfo relflects the
> correct speed when idle of
> 996000

Which governor are you using?  ondemand?

	Hannes
