Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbZD3WlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbZD3WlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZD3Wk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:40:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZD3Wk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:40:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: ptrace: selinux_bprm_committed_creds: simplify __wake_up_parent()
	code and s/parent/real_parent/
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 16:02:24 +0200 <20090429140224.GA31948@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	<1241011116.18249.193.camel@localhost.localdomain>
	<20090429140224.GA31948@redhat.com>
X-Zippy-Says: Why was I BORN?
Message-Id: <20090430223858.C6F47FC3BF@magilla.sf.frob.com>
Date: Thu, 30 Apr 2009 15:38:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
