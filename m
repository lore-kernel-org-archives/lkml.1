Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXAaCOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXAaCOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXAaCOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:14:45 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40150 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbXAaCOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:14:33 -0500
Date: Tue, 30 Jan 2007 21:14:05 -0500
From: Kyle McMartin <kyle@parisc-linux.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: parisc-linux@lists.parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __u64 rather than u64 in parisc statfs structs
Message-ID: <20070131021404.GA7088@athena.road.mcmartin.ca>
References: <200701281848.26804.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701281848.26804.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 06:48:26PM -0500, Mike Frysinger wrote:
> the statfs header exports some structs to userspace ... the parisc statfs64 
> struct currently uses u64 so the trivial attached patch fixes it to use __u64
> -mike

ack'd and merged. can you please not attach patches but properly send them
inline so i don't have to edit them before applying them to my tree?
