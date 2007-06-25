Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbXFYNyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbXFYNyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXFYNyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:54:11 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:51869 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbXFYNyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:54:09 -0400
Date: Mon, 25 Jun 2007 09:54:03 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Casey Schaufler <casey@schaufler-ca.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
In-Reply-To: <350610.33706.qm@web36610.mail.mud.yahoo.com>
Message-ID: <Line.LNX.4.64.0706250952350.21750@localhost.localdomain>
References: <350610.33706.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Casey Schaufler wrote:

> While there's lots of pain involved in developing an LSM
> modern development environments (e.g. virtual machines)
> have reduced the value of loadable modules for debug purposes.

lguest is pretty good for this.  You can boot a kernel in approximately 
the same time as loading a module.

-- 
James Morris
<jmorris@namei.org>
