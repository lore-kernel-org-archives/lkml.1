Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYJGVqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYJGVqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYJGVqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:46:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:50060 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbYJGVqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:46:33 -0400
Date: Wed, 8 Oct 2008 08:44:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
cc: linux-kernel@vger.kernel.org, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: RE: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
Message-ID: <alpine.LRH.1.10.0810080841400.11312@tundra.namei.org>
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Cihula, Joseph wrote:

> (large) Patch inline below (and still attached for those who prefer it).

It's now wordwrapped, and the other patches don't appear to have been 
resent at all.

Here's the appropriate section from SubmittingPatches.  Note the section 
on configuring your mailer.

----

7) No MIME, no links, no compression, no attachments.  Just plain text.

Linus and other kernel developers need to be able to read and comment
on the changes you are submitting.  It is important for a kernel
developer to be able to "quote" your changes, using standard e-mail
tools, so that they may comment on specific portions of your code.

For this reason, all patches should be submitting e-mail "inline".
WARNING:  Be wary of your editor's word-wrap corrupting your patch,
if you choose to cut-n-paste your patch.

Do not attach the patch as a MIME attachment, compressed or not.
Many popular e-mail applications will not always transmit a MIME
attachment as plain text, making it impossible to comment on your
code.  A MIME attachment also takes Linus a bit more time to process,
decreasing the likelihood of your MIME-attached change being accepted.

Exception:  If your mailer is mangling patches then someone may ask
you to re-send them using MIME.

See Documentation/email-clients.txt for hints about configuring
your e-mail client so that it sends your patches untouched.

----


-- 
James Morris
<jmorris@namei.org>
