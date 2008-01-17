Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYAQBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYAQBSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYAQBRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:17:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42852 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYAQBRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:17:46 -0500
Date: Wed, 16 Jan 2008 17:17:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/3]  Add bug/warn marker to generic report_bug()
Message-ID: <20080116171713.4d5f2f61@laptopd505.fenrus.org>
In-Reply-To: <20080117011000.GC24766@lixom.net>
References: <20080117010130.GA24663@lixom.net>
	<20080117011000.GC24766@lixom.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 19:10:00 -0600
Olof Johansson <olof@lixom.net> wrote:

> Powerpc uses the generic report_bug() from lib/bug.c to report
> warnings, and I'm guessing other arches do as well.
> 
> Add the module list as well as the end-of-trace marker to the output.
> This required making print_oops_end_marker() nonstatic.
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> 

All three are
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
