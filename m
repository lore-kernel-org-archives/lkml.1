Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbYGKMer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbYGKMer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYGKMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:34:37 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:47747 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYGKMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:34:37 -0400
Date: Fri, 11 Jul 2008 14:34:36 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] x86/pci: renamed: numa.c -> numaq_32.c
Message-ID: <20080711123436.GD10337@boogie.lpds.sztaki.hu>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com> <1215771521-6848-2-git-send-email-robert.richter@amd.com> <20080711123001.GC10337@boogie.lpds.sztaki.hu> <20080711123213.GA7963@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711123213.GA7963@erda.amd.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 02:32:14PM +0200, Robert Richter wrote:

> > Either fix the filename or just drop it completely.
> 
> Next patch in this series. This is only the git-mv.

Oh, sorry, I just realized that too. But wouldn't it be better to just
omit the file name?

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
