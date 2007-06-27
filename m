Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbXF0EZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbXF0EZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXF0EZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:25:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:47165 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXF0EZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:25:10 -0400
Date: Tue, 26 Jun 2007 21:24:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Crispin Cowan <crispin@novell.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070627042411.GW3723@sequoia.sous-sol.org>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com> <4681B611.1000704@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4681B611.1000704@novell.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Crispin Cowan (crispin@novell.com) wrote:
> and simple LSMs that can be
> unloaded safely can permit it.

there are none, and making the above possible is prohibitively
expensive.
