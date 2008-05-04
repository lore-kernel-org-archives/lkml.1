Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYEDIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYEDIpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYEDIpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:45:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39268 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYEDIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:45:31 -0400
Date: Sun, 4 May 2008 10:45:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4 usage statistics
Message-ID: <20080504104518.64b4ba9a@hyperion.delvare>
In-Reply-To: <20080428211812.GA19093@1wt.eu>
References: <20080428202433.GA13417@hera.kernel.org>
	<20080428205631.GA2813@cs181133002.pp.htv.fi>
	<20080428211812.GA19093@1wt.eu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On Mon, 28 Apr 2008 23:18:12 +0200, Willy Tarreau wrote:
> I'm really tempted by making a new attempt with 2.6.25, but let's let it
> settle down first.

You might want to wait a bit more and pick a version which will end up
in either SLES or RHEL. These tend to be maintained for longer than the
other versions. For example SLES10 is based on kernel 2.6.16, which is
still maintained by Adrian (or at least was maintained for a long time
- I don't know what the current status is.)

-- 
Jean Delvare
