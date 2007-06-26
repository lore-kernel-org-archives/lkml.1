Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXFZE0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXFZE0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXFZEZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:25:56 -0400
Received: from smtpout.mac.com ([17.250.248.172]:64718 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbXFZEZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:25:55 -0400
In-Reply-To: <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <40DBFB95-2E4B-4CB6-8A90-6A691DD45E70@mac.com>
Cc: James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Date: Tue, 26 Jun 2007 00:25:33 -0400
To: Andreas Gruenbacher <agruen@suse.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, typo:

On Jun 26, 2007, at 00:09:24, Kyle Moffett wrote:
> This sounds suspiciously like "The mere fact that the Linux-2.6-VM  
> cannot be built as a module is a rather weak argument for disabling  
> VFS modules as a whole"

Meant to say: "...disabling VM modules as a whole."

Cheers,
Kyle Moffett

