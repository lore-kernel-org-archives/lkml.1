Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYHCDC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYHCDC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYHCDAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:31 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39480 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbYHCDA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:26 -0400
Subject: Re: [PATCH] GDT SCSI DISK ARRAY: fix split line comments for grep
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: achim_leubner@adaptec.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com>
References: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 22:00:21 -0500
Message-Id: <1217732421.30264.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 08:44 +1000, Grant Coady wrote:
> Hi there,
> 
> Following patch unsplits some comment lines that hold driver device 
> names so they can be grepped.

I don't actually see a problem to be fixed here.  The original author
obviously split the lines to be under 80 chars.  The actual board names
are still integral in the comments and thus greppable even for the split
lines.  What is it that you think needs to be fixed?

James


