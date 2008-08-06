Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbYHFB1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbYHFB1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYHFBZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:25:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:33974 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762777AbYHFBZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:25:24 -0400
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 21:25:13 EDT
Date: Wed, 6 Aug 2008 10:53:06 +1000 (EST)
From: jmorris@namei.org
To: Rik van Riel <riel@redhat.com>
cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon
 access scanning
In-Reply-To: <20080805202231.5e46ccab@bree.surriel.com>
Message-ID: <alpine.LRH.1.10.0808061023230.7716@tundra.namei.org>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com> <1217948212.27684.120.camel@localhost.localdomain>
 <2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com> <1217956796.11547.12.camel@paris.rdu.redhat.com> <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805202231.5e46ccab@bree.surriel.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008, Rik van Riel wrote:

> What exactly are the threat models you want to protect against?
> 
> Once we have the answer to that question, we can figure out
> whether the current patch set addresses the threat model or
> whether alternate approaches are needed.

Alas, we've been here before.

http://article.gmane.org/gmane.linux.kernel/608634

  On Thu, 29 Nov 2007, Al Viro wrote:

  > Incidentally, I would really love to see the threat profile we are 
  > talking about.  

  Exactly.

  Please come up with a set of requirements that can be reviewed by the 
  core kernel folk, and perhaps then focus on how to meet those requirements
  once they have been accepted.

To be very clear, so we don't waste any _more_ time and effort on this: 

The anti-malware folk need to first provide a clearly understandable and 
complete description of the problem including a characterization of the 
threat.

The next step is to propose a design which addresses the problem, and to 
clearly and completely demonstrate how it does so.

Only then will it be possible to conduct an informed discussion on the 
underlying case for malware scanning and its possible implementation.



- James
-- 
James Morris
<jmorris@namei.org>
