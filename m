Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYAKPgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYAKPgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759182AbYAKPg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:36:26 -0500
Received: from emroute1.ornl.gov ([160.91.4.119]:43371 "EHLO emroute1.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758741AbYAKPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:36:25 -0500
Date: Fri, 11 Jan 2008 10:36:23 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [patch] block: fix blktrace timestamps
In-reply-to: <20080111102953.GA27223@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Message-id: <1200065783.7480.2.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <1199918912.8388.13.camel@lap75545.ornl.gov>
 <1199996752.9159.46.camel@lap75545.ornl.gov>
 <20080110234438.4826f658@inria.fr>
 <1200020661.5099.3.camel@obelisk.thedillows.org>
 <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu>
 <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu>
 <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 11:29 +0100, Ingo Molnar wrote:
> (David, could you try the patch further below - does it fix bkltrace 
> timestamps too?)

Jens already got back to you, but I can confirm it works here as well.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


