Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYAJNNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYAJNNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYAJNND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:13:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:44422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYAJNNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:13:01 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
From: Andi Kleen <andi@firstfloor.org>
References: <20080103442.621670000@suse.de>
	<20080110111514.GS25945@bingen.suse.de>
	<20080110112607.GE28740@does.not.exist>
	<200801101242.53504.ak@suse.de>
	<20080110124702.GF28740@does.not.exist>
Date: Thu, 10 Jan 2008 14:12:59 +0100
In-Reply-To: <20080110124702.GF28740@does.not.exist> (Adrian Bunk's message of "Thu\, 10 Jan 2008 14\:47\:02 +0200")
Message-ID: <p73fxx5omck.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:
>
> Technically you are the one who has to deal with problems in your 
> patches, not the people pointing at the problems.

If you believe that my patch adds a new problem then please describe
it clearly so that I can understand it.

-Andi
