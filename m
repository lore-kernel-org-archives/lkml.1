Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYAONrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYAONrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYAONrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:47:05 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53596 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYAONrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:47:02 -0500
Date: Tue, 15 Jan 2008 07:47:19 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: accensi@gmail.com, serue@us.ibm.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [patch 9/9] unprivileged mounts: add "no submounts" flag
Message-ID: <20080115134719.GB4453@sergelap.austin.ibm.com>
References: <20080108113502.184459371@szeredi.hu> <20080108113634.382855604@szeredi.hu> <20080114233910.GI6704@sergelap.austin.ibm.com> <E1JEjEE-0000xZ-RU@pomaz-ex.szeredi.hu> <643ea2b10801150253i735d7342q73bf01f864d6167c@mail.gmail.com> <E1JEjUx-00010q-Ny@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JEjUx-00010q-Ny@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Why not "nosubmnt"?
> 
> Why not indeed.  Maybe I should try to use my brain sometime.

Well it really should have 'user' or 'unpriv' in the name
somewhere.  'nosubmnt' is more confusing than 'nomnt' because
it no submounts really sounds like a reasonable thing in
itself...

But I never win naming arguments, so I accept that I have poor
naming judgement  :)

-serge
