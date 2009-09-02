Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZIBUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZIBUR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZIBUR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:17:26 -0400
Received: from ns1.co-raid.com ([12.51.113.4]:44380 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751941AbZIBUR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:17:26 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 2 Sep 2009 16:16:18 -0400
To: akpm@linux-foundation.org, ecashin@coraid.com, bonbons@linux-vserver.org,
       apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Message-ID: <ca183d6e3843acdd930c8854cf7d70bc@coraid.com>
In-Reply-To: <20090902125540.9fc9d582.akpm@linux-foundation.org>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<9ab0e087296715d764071d4d39542985@coraid.com>
	<20090829154305.723fd86c@neptune.home>
	<6309cc7d77486e24aca5130ec5802dfb@coraid.com>
	<20090902125540.9fc9d582.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Sep  2 15:55:47 EDT 2009, akpm@linux-foundation.org wrote:
> On Tue, 1 Sep 2009 15:15:20 -0400
> Ed Cashin <ecashin@coraid.com> wrote:
> 
> > The patch looks fine to me.
> 
> I translated that into Acked-by:.
> 
> > I don't think it should go in my aoe tree for linux-next, since the
> > patch addresses a regression.
> > 
> > Based on the series file in mmotm, I don't think this patch is in mm
> > at the moment.  Andrew Morton, do you think this patch should go
> > through your mm tree?
> 
> I have it now.  Please check that the below is the right patch and that
> my cobbled-together changelog makes sense (if not, please send
> replacement changelog and/or patch).

Thanks.  It looks good to me.

-- 
  Ed
