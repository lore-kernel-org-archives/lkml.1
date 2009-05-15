Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbZEOMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbZEOMSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbZEOMSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:18:09 -0400
Received: from gate.in-addr.de ([212.8.193.158]:45013 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761718AbZEOMSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:18:07 -0400
Date: Fri, 15 May 2009 14:18:38 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 13/16] DRBD: misc
Message-ID: <20090515121838.GK8610@suse.de>
References: <1242389443-3470-5-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-6-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-7-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-8-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-9-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-10-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-11-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-12-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-13-git-send-email-philipp.reisner@linbit.com> <1242389443-3470-14-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1242389443-3470-14-git-send-email-philipp.reisner@linbit.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-05-15T14:10:40, Philipp Reisner <philipp.reisner@linbit.com> wrote:

> buildtag.c tag will go away when we are not longer an external module.

So I would assume it shouldn't be part of the upstream submission? ;-)


Regards,
    Lars

-- 
SuSE Labs, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

