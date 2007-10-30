Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbXJ3NA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbXJ3NA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXJ3NAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:00:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:18154 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXJ3NAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Q8z5+srlK/Q+uLlpdu4ifqzdFAyx7cEqSLfL1cezPAdI+TLdY96FkFPNX1QYnQN4HWzFbaIA6E7t28W3uJ6T1bEs5QESoDK39LoC7vdVVUh5etNkxso8DnR7Eq5lNlb/rpgg0Lf9JlXDyf9eSctMIJGre5wwIT1yLJ0IQx2CCZA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
Date: Tue, 30 Oct 2007 13:00:03 +0000
User-Agent: KMail/1.9.1
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <471E6313.1040704@garzik.org> <1193232490.3396.10.camel@localhost.localdomain> <20071024142729.GZ27248@parisc-linux.org>
In-Reply-To: <20071024142729.GZ27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301300.03996.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 15:27, Matthew Wilcox wrote:
> On Wed, Oct 24, 2007 at 09:28:10AM -0400, James Bottomley wrote:
> > OK, so it's no secret that I'm the last of the subsystem maintainers
> > whose day job isn't working on the linux kernel.  If you want a full
> > time person, who did you have in mind?
> 
> I'm willing to take on the role of scsi git-monkey.  Alternatively, we
> could split the scsi maintainer role the same way that Dave and Jeff
> do for net where Dave handles the core and Jeff handles the drivers.
> Or we can negotiate some other arrangement.

That would be great. Maybe my aic7xxx debloating patches
which were submitted four times already (IIRC)
will be looked at at last.
--
vda
