Return-Path: <linux-kernel-owner+w=401wt.eu-S933917AbXELA0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbXELA0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbXELA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:26:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759475AbXELA0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:26:36 -0400
Date: Fri, 11 May 2007 17:26:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Oliver Xymoron <oxymoron@waste.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB under lguest on i386
In-Reply-To: <20070511213336.GX11166@waste.org>
Message-ID: <Pine.LNX.4.64.0705111725510.27616@schroedinger.engr.sgi.com>
References: <20070511213336.GX11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Oliver Xymoron wrote:

> And no sign of further progress. SLAB worked fine.

Add slub_debug to the command line. Any changes or any additional 
diagnostic output?


