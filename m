Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZDGKwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZDGKwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZDGKw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:52:28 -0400
Received: from gate.in-addr.de ([212.8.193.158]:42248 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751721AbZDGKw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:52:28 -0400
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 06:52:27 EDT
Date: Tue, 7 Apr 2009 12:26:31 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] DRBD: a block device for HA clusters
Message-ID: <20090407102631.GI11117@suse.de>
References: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-03-30T18:47:08, Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Hi,
> 
>   This is a repost of DRBD, to keep you updated about the ongoing
>   cleanups.

Hi Philipp,

thanks for the submission!

On reading the code, I think it is in pretty good shape to be merged for
linux-next or Andrew's tree, at the very least.

(Ultimately, of course it'd be very nice if we could reduce the number
of raid engines in the kernel, but that should not necessarily delay the
merge here. Like Greg likes to say, the kernel community also merges
tons of hardware drivers in much worse states.)

Maybe you could also provide a git repository of a kernel tree with your
patches where testers could pull from?


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

