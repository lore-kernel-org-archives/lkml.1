Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYA2Xn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYA2Xn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYA2Xnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:43:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49394 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYA2Xns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:43:48 -0500
Date: Tue, 29 Jan 2008 16:43:45 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: PCI x86: always use conf1 to access config space below 256 bytes
Message-ID: <20080129234345.GB14088@parisc-linux.org>
References: <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129025743.GD20198@parisc-linux.org> <20080129132108.GD10761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129132108.GD10761@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 05:21:08AM -0800, Greg KH wrote:
> Hm, who wrote this, Ivan?
> 
> If so, Matthew, please do not strip off authorship of patches, and place
> a "From:" line on the first line above the description, so it is not
> lost.

Sorry, I didn't know that was the convention.  I thought the first
Signed-off-by: was assumed to be the author.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
