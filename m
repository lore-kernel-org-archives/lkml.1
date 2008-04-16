Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbYDPCNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbYDPCNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYDPCNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:13:17 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:11143 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYDPCNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:13:16 -0400
Date: Tue, 15 Apr 2008 20:13:15 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pbadari@us.ibm.com, linux-kernel@vger.kernel.org, linas@austin.ibm.com
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080416021314.GA3333@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-kernel@vger.kernel.org, linas@austin.ibm.com
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080415173656.218a6080.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415173656.218a6080.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> Alex Chiang <achiang@hp.com> wrote:
> 
> > This patch is a complete guess on my part (since I've not been
> > able to understand pseries architecture) but I think it should
> > fix your issue.
> > 
> > Can you give it a try and let me know? It applies on top of the
> > -mm tree that includes my physical pci_slot series.
> > 
> > Also, I'm hoping Linas will speak up and let me know what the
> > real answer might be. ;)
> 
> Did we hear back from Badari on this?

Haven't heard a peep. :(

Badari? Did it help?

Thanks.

/ac

