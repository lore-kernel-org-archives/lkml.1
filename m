Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZBSPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZBSPCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZBSPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:02:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54289 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751667AbZBSPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:02:42 -0500
Date: Thu, 19 Feb 2009 10:02:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
cc: linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
In-Reply-To: <20090219135352.GA28717@silver.sucs.org>
Message-ID: <Pine.LNX.4.44L0.0902191002160.3012-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Sitsofe Wheeler wrote:

> Hi,
> 
> There appears to be a regression from 2.6.28 in how disk errors are
> handled in 2.6.29rc5 - rather than trying and eventually giving up, it
> appears to try (and report) forever. 

See this thread and patch:

	http://marc.info/?l=linux-kernel&m=123490148422684&w=2

Alan Stern

