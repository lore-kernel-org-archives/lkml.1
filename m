Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYDIQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYDIQya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYDIQyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:54:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYDIQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:54:22 -0400
Date: Wed, 9 Apr 2008 09:53:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-Id: <20080409095326.8e306c41.akpm@linux-foundation.org>
In-Reply-To: <20080409135840.GO17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
	<20080408171257.GF17915@shadowen.org>
	<87ej9gp6ol.fsf@basil.nowhere.org>
	<20080409081943.GI17915@shadowen.org>
	<20080409083013.GJ17915@shadowen.org>
	<20080409084606.GD19010@one.firstfloor.org>
	<20080409131420.GL17915@shadowen.org>
	<alpine.LNX.1.10.0804091517260.4411@fbirervta.pbzchgretzou.qr>
	<20080409135840.GO17915@shadowen.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008 14:58:40 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> The originally suggested layout was:
> 
> 			printk(
> "Oh ....",
> 				a, b);

Dunno about others, but when I see that idiom I fall over stunned and 
can't get up again.
