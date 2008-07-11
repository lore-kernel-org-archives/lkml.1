Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYGKWmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYGKWmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYGKWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:42:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:47799 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYGKWmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:42:13 -0400
Date: Fri, 11 Jul 2008 16:42:11 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [PATCH for bkl-removal v2] IB/umad: BKL is not needed for
 ib_umad_open()
Message-ID: <20080711164211.4414a692@bike.lwn.net>
In-Reply-To: <adaod54m99r.fsf@cisco.com>
References: <aday748mad3.fsf@cisco.com>
	<adaod54m99r.fsf@cisco.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 13:54:40 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> Remove explicit lock_kernel() calls and document why the code is safe.

Applied to the bkl-removal tree and pushed - thanks.

jon
