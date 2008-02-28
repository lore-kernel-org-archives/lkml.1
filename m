Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYB1Upj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYB1Upj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760729AbYB1Up2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:45:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50858 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097AbYB1Up1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:45:27 -0500
Message-ID: <47C71D65.7020308@garzik.org>
Date: Thu, 28 Feb 2008 15:45:25 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 'git gc' always run, on old kernel repo?
References: <47C71233.4050705@garzik.org> <47C715EB.3060303@garzik.org> <alpine.LFD.1.00.0802281533190.4911@xanadu.home>
In-Reply-To: <alpine.LFD.1.00.0802281533190.4911@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> On Thu, 28 Feb 2008, Jeff Garzik wrote:
> 
>>> warning: There are too many unreachable loose objects; run 'git prune' to
>>> remove them.
>> Will the 'git gc' never end???
> 
> What happens if you try to run "git prune"?

Same behavior.

FWIW I run "git prune" immediately prior to "git push", _every_ time I 
push to master.kernel.org (git.kernel.org).

	Jeff



