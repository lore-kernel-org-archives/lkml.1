Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbZCRUiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbZCRUiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZCRUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:32:05 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57859 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZCRUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qdLLbNz73z4d6uGE9aLfpaMWVd8ucDbRw1Im5HZ7smtNWJuAZPCUJ+d6CsNSfz6aTp
         AtcHjYUycSe9ukmV9KhHY/vybFxWkmYoBJEDnU32xvztUN9w6MmPVGA9g5yktJ1k3yVd
         qNSys8EJTsVOThFQYYEnfEP8NCGQzp99H1nwc=
MIME-Version: 1.0
In-Reply-To: <20090318173221.GA16077@fieldses.org>
References: <1237393292-14934-1-git-send-email-bfields@fieldses.org>
	 <1237393292-14934-2-git-send-email-bfields@fieldses.org>
	 <1237393292-14934-3-git-send-email-bfields@fieldses.org>
	 <20090318170843.GA29045@us.ibm.com>
	 <20090318173221.GA16077@fieldses.org>
Date: Wed, 18 Mar 2009 23:31:43 +0300
Message-ID: <f44001920903181331t6b4d6d2ev622d57604ba24866@mail.gmail.com>
Subject: Re: [PATCH] nfsd: nfsd should drop CAP_MKNOD for non-root
From: Igor Zhbanov <izh1979@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's good and I'm glad to see patch for CAP_NFSD_MASK in git. Thanks. :-)
Waiting for CAP_FS_MASK to be fixed too.

By the way, I don't see git repository for 2.4.x kernel. Could you fix
2.4.x too?
