Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYIINUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYIINUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYIINUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:20:40 -0400
Received: from scing.com ([217.160.110.58]:57511 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYIINUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:20:39 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Tue, 9 Sep 2008 15:20:35 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809091335.17559.j@jannau.net> <20080909130311.GA4085@one.firstfloor.org>
In-Reply-To: <20080909130311.GA4085@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091520.35694.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:03:11 Andi Kleen wrote:
> > pr_printk is not found in include/ nor by google. please explain
>
> pr_debug() sorry.

pr_debug() does something else. that dprintk macro prints depending on a 
module parameter

Janne
