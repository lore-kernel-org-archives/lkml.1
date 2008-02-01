Return-Path: <linux-kernel-owner+w=401wt.eu-S1762518AbYBAMzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762518AbYBAMzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbYBAMyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:54:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:59685 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYBAMyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=rlLvJ8VNGVXamJ7ZzL4MTURqXBEQ+QqrJ7NpiZRfwWYjcAB6iLSA3oMF8s8lwkZQ1QNBmEKdGxGzVyE8FGiKD1vDfr1Kg2ghNNwzwjRd6QC132eP/Q73YkZrW0YoaSDMOuEb8K79X+2CrSrCRZaIQEhqmaAs2gjP3lwMbS2OhIU=
Date: Fri, 1 Feb 2008 13:54:37 +0100
To: Paul Mundt <lethal@linux-sh.org>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/KCONFIG] - Add SUPERH depends to sound/soc/sh/Kconfig
Message-Id: <20080201135437.02fcdeb1.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080131231715.GB16399@linux-sh.org>
References: <20080131225811.a175de2c.Kristoffer.ericson@gmail.com>
	<20080131231715.GB16399@linux-sh.org>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 08:17:15 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Thu, Jan 31, 2008 at 10:58:11PM +0100, Kristoffer Ericson wrote:
> > Currently you will see an empty "SoC Audio support for SuperH" menu 
> > when building for other archs (example pxa).
> > This patch adds "depends on SUPERH" to remove that empty menu.
> > 
> > signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> > 
> Yeah, I noticed that too. Please send this to the ALSA folks.

Done, just got message from takashi that its applied. Thx
