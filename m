Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZJLUXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZJLUXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZJLUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:23:37 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52220 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754153AbZJLUXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:23:36 -0400
Date: Mon, 12 Oct 2009 16:16:01 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Real time kernel
In-Reply-To: <2d05c4580910121100v702cbdddua9bd8de971fecaa2@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910121615100.5363@gentwo.org>
References: <2d05c4580910121100v702cbdddua9bd8de971fecaa2@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Dragoslav Zaric wrote:

> If you build kernel 2.6 with preemption configured in,
> do you get real-time operation system ?

Depends on what you mean by realtime. If you want a slower kernel with
less outliers then enable preempt.

