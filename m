Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CLAq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:46:58 -0500
Received: from viefep34-int.chello.at ([62.179.121.52]:43997 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0CLAq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:46:57 -0500
X-Greylist: delayed 2901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 19:46:56 EST
X-SourceIP: 80.219.150.52
From: Andrew Baumann <andrewb@inf.ethz.ch>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI: Cannot allocate resource regions of bridge and device in ThinkPad dock
Date: Fri, 12 Mar 2010 00:58:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-20-generic; KDE/4.3.5; x86_64; ; )
Cc: Andrew Baumann <andrewb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org,
       Lara Michaels <laramichaels1978@yahoo.com>
References: <200607061345.31486.andrewb@cse.unsw.edu.au> <201003111305.04989.bjorn.helgaas@hp.com>
In-Reply-To: <201003111305.04989.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003120058.28812.andrewb@inf.ethz.ch>
X-Cloudmark-Analysis: v=1.1 cv=dFTJNr//OApgz790TnY+O6n+VSjuGIjvlcM+aYgYbcs= c=1 sm=0 a=YJzpEBQmW5sA:10 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=TMJznFnfaKKn4djCK9kA:9 a=kKhdN9KvISzmDiJvmzCotjw-xawA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 21.05:04 Bjorn Helgaas wrote:
> On Wednesday 05 July 2006 09:45:31 pm Andrew Baumann wrote:
> > I'm unable to use a radeon card installed in the PCI slot of a thinkpad
> > docking station. This is from a clean boot in the dock (no hot
> > dock/undock), and appears on vendor-provided 2.6.16 and 2.6.17 kernels,
> > as well as on a self-built 2.6.17-git25 tree.
> 
> Did you ever get this ancient (2006!) issue resolved?  I didn't see
> any responses on the list, and Lara is having a sort of similar issue:
>   http://bugzilla.kernel.org/show_bug.cgi?id=15436
> 
> I think your problem was that Linux saw the Radeon card but didn't assign
> resources correctly, while in Lara's case, Linux doesn't see the card at
> all.

Wow, that is ancient! I'm afraid I can't help you, as I no longer have the 
hardware in question, but I found some sort of workaround. It either involved 
kernel boot parameters or a newer version of the kernel, and I don't recall 
the details, but I did eventually get the card to work.

Sorry this isn't any use,
Andrew
