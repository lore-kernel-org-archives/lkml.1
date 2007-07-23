Return-Path: <linux-kernel-owner+w=401wt.eu-S934410AbXGWTxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbXGWTxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763113AbXGWTx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:53:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45805 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761974AbXGWTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:53:25 -0400
Date: Mon, 23 Jul 2007 12:53:23 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
Message-ID: <20070723125323.27a864f7@schroedinger.engr.sgi.com>
In-Reply-To: <469DAA52.1010803@gmail.com>
References: <4698BF14.10807@googlemail.com>
	<a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	<469A5C94.7030201@googlemail.com>
	<a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>
	<469A9D5D.10509@googlemail.com>
	<469B61C8.8010902@googlemail.com>
	<a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	<469BB7B8.3060002@gmail.com>
	<469BB9CA.6090500@googlemail.com>
	<469BC2D6.5090008@googlemail.com>
	<469BC34C.4080107@googlemail.com>
	<469DAA52.1010803@gmail.com>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 14:51:14 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Okay, successfully reproduced here.  Will hunt down.

Next time simply boot with "slub_debug". It will save a lot of time.

