Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbXGWTw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbXGWTw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbXGWTwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:52:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45744 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765374AbXGWTwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:52:19 -0400
Date: Mon, 23 Jul 2007 12:52:18 -0700
From: Christoph Lameter <clameter@sgi.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       htejun@gmail.com, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
Message-ID: <20070723125218.78834f06@schroedinger.engr.sgi.com>
In-Reply-To: <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
References: <4698BF14.10807@googlemail.com>
	<a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	<469A5C94.7030201@googlemail.com>
	<a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>
	<469A9D5D.10509@googlemail.com>
	<469B61C8.8010902@googlemail.com>
	<a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 20:49:03 +0530
"Satyam Sharma" <satyam.sharma@gmail.com> wrote:


> I'm thoroughly mystified ... Christoph? Tejun? Someone?

It would help to boot with "slub_debug" to find out what corrupted the
data.
