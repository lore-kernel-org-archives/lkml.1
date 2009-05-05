Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZEEEGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZEEEGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZEEEGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:06:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZEEEGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:06:11 -0400
Date: Mon, 4 May 2009 21:05:41 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Lars Marowsky-Bree <lmb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
In-Reply-To: <20090501111554.GW12180@suse.de>
Message-ID: <alpine.DEB.2.01.0905042103010.6162@bogon.housecafe.de>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <20090501015902.ed8b56d3.akpm@linux-foundation.org> <20090501111554.GW12180@suse.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18JEqh3fWD81IsyjpIt0mC/bP1k1jMcy1EmG8a
 4bFE9QgYCcyiYBEYD6MiA8Qpfo1fer8QsX5jOhiLWrSijUA1t3
 zkde/flaSLkdm+98fW0yQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Lars Marowsky-Bree wrote:
> It is used by many customers (thousands world-wide, I'm sure) to
> replicate block device data locally (to replace more expensive SANs
> while achieving higher availablity) or async/remotely (for disaster
> recovery).

While covering Linux-HA success stories really, most of them are using 
DRBD as well: http://moin.linux-ha.org/lha/SuccessStories

C.
-- 
Bruce Schneier does not sleep. He prempts everything.
