Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZAEDhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZAEDhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZAEDhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:37:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51057 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZAEDhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:37:06 -0500
Date: Sun, 4 Jan 2009 21:37:02 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090105033702.GA9571@us.ibm.com>
References: <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org> <20090105031827.GA10185@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105031827.GA10185@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> seemingly natural could be confusing in cases like this.
> cap_set_acting() -  i like it...

(Yes, please ignore that.  I'm going to sleep.)

-serge
