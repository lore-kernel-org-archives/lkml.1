Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXICLet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXICLet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXICLem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:34:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbXICLem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:34:42 -0400
Date: Mon, 3 Sep 2007 04:33:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access
 for AMD Barcelona
Message-ID: <20070903043319.7573875b@laptopd505.fenrus.org>
In-Reply-To: <20070903091718.GB22144@alberich.amd.com>
References: <20070903081736.288288000@amd.com>
	<20070903081736.588599000@amd.com>
	<20070903013157.72c94891@laptopd505.fenrus.org>
	<20070903091718.GB22144@alberich.amd.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 11:17:18 +0200
"Andreas Herrmann" <andreas.herrmann3@amd.com> wrote:
\> 
> Do you see any other issues besides the naming of the bit?

I wonder if we should key this off a PCI ID of the chipset rather than
the cpu id... I mean, how sure are you that all via chipsets connected
to the barcelona cpu will deal well?
