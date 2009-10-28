Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZJ1Uq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZJ1Uq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZJ1Uq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:46:26 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51492 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbZJ1UqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:46:25 -0400
Date: Wed, 28 Oct 2009 21:46:28 +0100
From: Andreas Mohr <andi@lisas.de>
To: Igor Chudov <ichudov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading on 4 core CPU DECREASES performance???
Message-ID: <20091028204628.GA8519@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I would like to know how can I make the scheduler to prefer to spread
> the tasks across physical cores as opposed to bundling two on one core
> and leaving some cores idle.

Did you have /sys/devices/system/cpu/sched_smt_power_savings activated?

Andreas Mohr
