Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYGRWn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYGRWn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbYGRWnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:43:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:20954 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757176AbYGRWno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:43:44 -0400
Date: Sat, 19 Jul 2008 07:43:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] input: Clean up maple keyboard driver
Message-ID: <20080718224323.GA19263@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-input <linux-input@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1213559019.22707.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213559019.22707.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 08:43:39PM +0100, Adrian McMenamin wrote:
> Have a single probe function instead of a probe and a connect function.
> Also tidy a comment.
> 1 files changed, 33 insertions(+), 48 deletions(-)
> 
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Ok, so I was going to take this through my tree, but it doesn't apply any
more. Please send an updated version that can be merged.
