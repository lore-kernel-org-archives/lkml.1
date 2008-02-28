Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbYB1UhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbYB1UhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932467AbYB1Ugl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:36:41 -0500
Received: from relais.videotron.ca ([24.201.245.36]:47877 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbYB1Ugj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:36:39 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 28 Feb 2008 15:36:33 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Jeff Garzik <jeff@garzik.org>
Cc: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 'git gc' always run, on old kernel repo?
In-reply-to: <47C715EB.3060303@garzik.org>
Message-id: <alpine.LFD.1.00.0802281533190.4911@xanadu.home>
References: <47C71233.4050705@garzik.org> <47C715EB.3060303@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Jeff Garzik wrote:

> > warning: There are too many unreachable loose objects; run 'git prune' to
> > remove them.
> 
> Will the 'git gc' never end???

What happens if you try to run "git prune"?


Nicolas
