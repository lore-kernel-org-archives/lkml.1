Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZAFJyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZAFJyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZAFJyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:54:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:53291 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZAFJya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:54:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xJ0HCYcVgl4NYGtq6XI6in/jJsIfkPC5sivsN8UnV+4eLvmplQyCB/c20U76RZF8fK
         bu+zaFsmoTm6DP4HoYRHni6l6n1oOsOvHeUDXcyPGInZbl4RZNdx6rSKQFqgY3QrQH+5
         +3h0ef5mI6JTr5WcEluNaJgzrPIAl2zlwAM/A=
Date: Tue, 6 Jan 2009 12:46:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de, riel@redhat.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
Message-ID: <20090106094615.GE7671@localhost>
References: <20090105103132.GD7645@localhost> <20090105163742.08777d73.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105163742.08777d73.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Mon, Jan 05, 2009 at 04:37:42PM -0800]
...
| The patch adds nearly 300 bytes of stuff to mm/sparse.o, and for what??
| 
...

No need to apply it. Sorry for noise.

		- Cyrill -
