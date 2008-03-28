Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYC1RsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYC1RsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYC1Rrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:47:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbYC1Rrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:47:52 -0400
Date: Fri, 28 Mar 2008 14:47:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
Message-ID: <20080328144708.0ef1dad4@gaivota>
In-Reply-To: <47ED2A46.1010407@gmail.com>
References: <47ECD0CF.1020003@gmail.com>
	<87y783jdjo.fsf@basil.nowhere.org>
	<47ECD715.90507@gmail.com>
	<20080328113803.GQ29105@one.firstfloor.org>
	<47ECE318.1030809@gmail.com>
	<20080328133537.GS29105@one.firstfloor.org>
	<20080328142408.6c8dc198@gaivota>
	<47ED2A46.1010407@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 18:26:30 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 03/28/2008 06:24 PM, Mauro Carvalho Chehab wrote:
> > It seems that the problem you're suffering is specific to some driver.
> 
> It's pseudo vivi.c

Ok, I've added the handler for compat32. I didn't test with skype yet.

Cheers,
Mauro
