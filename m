Return-Path: <linux-kernel-owner+w=401wt.eu-S1765655AbYCTAAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765655AbYCTAAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162272AbYCSWrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:47:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162267AbYCSWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:46:59 -0400
Subject: Re: preempt_disable() question
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rick Brown <rick.brown.3@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
References: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 23:46:52 +0100
Message-Id: <1205966812.6437.38.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 07:44 +0530, Rick Brown wrote:
> Hi,
> 
> I've asked this on kernel newbies before, but not enough responses.
> 
> Does preempt_disable() disable preemption on all the processors, or
> just the local processor?

Just the local one

