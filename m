Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYANVhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYANVhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYANVhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:37:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYANVhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:37:40 -0500
Date: Mon, 14 Jan 2008 13:38:02 -0800
From: Greg KH <gregkh@suse.de>
To: "Oliver Pinter (Pint?r Oliv?r)" <oliver.pntr@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Message-ID: <20080114213802.GA7860@suse.de>
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com> <20080114125200.28cb4c69@deepthought> <20080114210105.GG9847@does.not.exist> <6101e8c40801141331n3cb66c04pc74ff07faf04c8fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40801141331n3cb66c04pc74ff07faf04c8fd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:31:03PM +0100, Oliver Pinter (Pint?r Oliv?r) wrote:
> I think, it is a potential security breakpoint, when applications with
> root permission its read, then a machine is freezed, or only i thin
> it's?

I'm sorry, I don't quite understand what you are trying to say here.
