Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYGEQRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYGEQRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 12:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYGEQQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 12:16:56 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50667 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751532AbYGEQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 12:16:55 -0400
Date: Sat, 5 Jul 2008 12:16:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4 : Remove unused variable journal from
	ext4_show_options
Message-ID: <20080705161646.GC20240@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
References: <ea11fea30806301155u3daccf0eo2daf690396b5616f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30806301155u3daccf0eo2daf690396b5616f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for submitting the patch!  This is already in the ext4 patch
queue to be pushed at the next merge window.  (I submitted the exact
same patch to linux-ext4 as a cleanup a month ago.)

     	      		      	      	- Ted
