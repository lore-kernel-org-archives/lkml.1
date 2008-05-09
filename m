Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYEIPf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYEIPf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYEIPfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:35:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13318 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYEIPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:35:21 -0400
Date: Fri, 9 May 2008 17:35:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Andries Brouwer <aeb@cwi.nl>
Subject: Re: [PATCH] fs: Prefer strlcpy() over snprintf()
Message-ID: <20080509173513.328eff12@hyperion.delvare>
In-Reply-To: <1210335354.3635.486.camel@quoit>
References: <20080509134211.02eb2058@hyperion.delvare>
	<1210335354.3635.486.camel@quoit>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Fri, 09 May 2008 13:15:54 +0100, Steven Whitehouse wrote:
> The patch looks good, but could you break this into bits? Its easier for
> me just to put the GFS2 bit through my git tree and the other bits
> should probably go via another route,

Thanks for the review. No problem, I'll split the patch and send the
individual bits to their respective maintainers now.

-- 
Jean Delvare
