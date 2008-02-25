Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYBYFFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYBYFFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYBYFFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:05:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYBYFFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:05:04 -0500
Date: Mon, 25 Feb 2008 02:04:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: add a clamp() macro to kernel.h and replace two
 existing defs
Message-ID: <20080225020412.09dc474c@areia>
In-Reply-To: <1203914603.1767.25.camel@brick>
References: <1203914603.1767.25.camel@brick>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 20:43:23 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Clamps a value to be within a given range with strict typechecking.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
