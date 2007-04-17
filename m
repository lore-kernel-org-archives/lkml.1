Return-Path: <linux-kernel-owner+w=401wt.eu-S1031268AbXDQV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031268AbXDQV6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031270AbXDQV6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:58:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031268AbXDQV6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:58:38 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <Line.LNX.4.64.0704161846110.13905@d.namei>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 17:55:17 -0400
Message-Id: <1176846917.5946.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
> On Mon, 16 Apr 2007, John Johansen wrote:
> 
> > Label-based security (exemplified by SELinux, and its predecessors in
> > MLS systems) attaches security policy to the data. As the data flows
> > through the system, the label sticks to the data, and so security
> > policy with respect to this data stays intact. This is a good approach
> > for ensuring secrecy, the kind of problem that intelligence agencies have.
> 
> Labels are also a good approach for ensuring integrity, which is one of 
> the most fundamental aspects of the security model implemented by SELinux.  
> 
> Some may infer otherwise from your document.
> 

Not only that, the implication that secrecy is only useful to
intelligence agencies is pretty funny. Personally, I think that
protecting the confidentiality of my data is important (and my bank and
health care providers protecting the data they have about me). Type
Enforcement was specifically designed to be able to address integrity
_and_ confidentiality in a way acceptable to commercial organizations.

Karl


