Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbYH0REq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbYH0REq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYH0REg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:04:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYH0REf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:04:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200808271857.48651.agruen@suse.de>
References: <200808271857.48651.agruen@suse.de> <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 18:04:12 +0100
Message-ID: <27765.1219856652@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher <agruen@suse.de> wrote:

> > (Also note that if you have such users, you'll want to ask David
> > Howells not to push the patch he has floated removing the ability to
> > pass caps to another task altogether when
> > CONFIG_SECURITY_FILE_CAPABILITIES=n :)
> 
> I was actually about to ask for making this behavior change pertinent instead 
> of having it depend on CONFIG_SECURITY_FILE_CAPABILITIES :)

Do you mean 'permanent' rather than 'pertinent'?

David
