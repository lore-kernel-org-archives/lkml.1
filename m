Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbXF2U5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbXF2U5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXF2U5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:57:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbXF2U5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:57:35 -0400
Date: Fri, 29 Jun 2007 13:57:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mingming Caoc <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
       xfs@oss.sgi.com
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-Id: <20070629135709.6cf0264d.akpm@linux-foundation.org>
In-Reply-To: <46852A2C.9040407@us.ibm.com>
References: <20070512080157.GF85884050@sgi.com>
	<20070612061652.GA6320@amitarora.in.ibm.com>
	<20070613235217.GS86004887@sgi.com>
	<20070614091458.GH5181@schatzie.adilger.int>
	<20070614120413.GD86004887@sgi.com>
	<20070614193347.GN5181@schatzie.adilger.int>
	<20070625132810.GA1951@amitarora.in.ibm.com>
	<20070628025543.9467216f.akpm@linux-foundation.org>
	<20070628175757.GA1674@amitarora.in.ibm.com>
	<20070628113342.c9c0f49c.akpm@linux-foundation.org>
	<20070629135612.GH29279@thunk.org>
	<46852A2C.9040407@us.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 11:50:04 -0400
Mingming Caoc <cmm@us.ibm.com> wrote:

> I think the ext4 patch queue is in good shape now.

Which ext4 patches are you intending to merge into 2.6.23?

Please send all those out to lkml for review?
