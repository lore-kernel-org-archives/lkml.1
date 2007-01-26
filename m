Return-Path: <linux-kernel-owner+w=401wt.eu-S1030794AbXAZHsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030794AbXAZHsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 02:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030793AbXAZHsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 02:48:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43464 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030786AbXAZHsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 02:48:53 -0500
Message-ID: <45B9B263.8060409@garzik.org>
Date: Fri, 26 Jan 2007 02:48:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] sata_mv: conversion to new EH
References: <20070126070632.GA17323@havoc.gtf.org>
In-Reply-To: <20070126070632.GA17323@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> This is the first cut at converting sata_mv to new EH.
> 
> It builds, but is untested.
> 
> Done:
> - freeze, thaw
> - hardreset
> - prereset, software: intentionally not implemented

s/software/softreset/

