Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZHBSln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZHBSln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZHBSlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:41:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:56288 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZHBSll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:41:41 -0400
Date: Sun, 2 Aug 2009 19:41:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/15] arch/mips: Use DIV_ROUND_CLOSEST
Message-ID: <20090802184024.GB9058@linux-mips.org>
References: <Pine.LNX.4.64.0908021047480.15557@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908021047480.15557@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 10:48:08AM +0200, Julia Lawall wrote:

> 
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.

Applied.  Thanks Julia!

  Ralf
