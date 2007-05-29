Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXE2Tos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXE2Tos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXE2Tog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:44:36 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbXE2Tof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:44:35 -0400
Date: Tue, 29 May 2007 12:43:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Richard Purdie <richard@openedhand.com>,
       Edward Shishkin <edward@namesys.com>
Subject: Re: [RFC] [-mm] Remove 'unsafe' LZO decompressor
Message-Id: <20070529124358.133ece14.akpm@linux-foundation.org>
In-Reply-To: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
References: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 18:15:17 +0100
Michael-Luke Jones <mlj28@cam.ac.uk> wrote:

> The patch removes the 'unsafe' LZO decompression function

Guys, I'll drop all the lzo patches from -mm.  Please wake me up when
we've decided what we want to do.
