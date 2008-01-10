Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYAJIa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYAJIa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYAJIas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:30:48 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49194 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYAJIas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:30:48 -0500
Message-ID: <4785D7B2.3030201@bull.net>
Date: Thu, 10 Jan 2008 09:30:42 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ricknu-0@student.ltu.se, nadia.derbey@bull.net,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm] new warning in ipc/msg.c
References: <4784EB6A.5020604@bull.net> <20080109151319.edff136c.akpm@linux-foundation.org>
In-Reply-To: <20080109151319.edff136c.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/01/2008 09:38:58,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/01/2008 09:39:02,
	Serialize complete at 10/01/2008 09:39:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Doing this in a piecemeal through-a-pinhole fashion won't work very well
> and is a bit risky.

Yes, agree, that's also my feeling.

-- 
Pierre Peiffer
