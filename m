Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbXJZOle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbXJZOle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbXJZOlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:41:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbXJZOlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:41:11 -0400
Date: Fri, 26 Oct 2007 07:37:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20071026073721.618b4778@laptopd505.fenrus.org>
In-Reply-To: <20071026064024.243943043@suse.de>
References: <20071026064024.243943043@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 23:40:24 -0700
jjohansen@suse.de wrote:

before going into the LSM / security side of things, I'd like to get
the VFS guys to look at your VFS interaction code.

In addition, I'd like to ask you to put a file in Documentation/
somewhere that describes what AppArmor is intended security protection
is (it's different from SELinux for sure for example); by having such a
document for each LSM user, end users and distros can make a more
informed decision which module suits their requirements... and it also
makes it possible to look at the implementation to see if it has gaps
to the intent, without getting into a pissing contest about which
security model is better; but unless the security goals are explicitly
described that's a trap that will keep coming back... so please spend
some time on getting a good description going here..

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
