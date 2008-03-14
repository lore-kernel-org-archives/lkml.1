Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYCNOMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYCNOMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYCNOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:12:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYCNOMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:12:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PeHgCEOhinYVHOJQ+RXtZDy3CpsID3dUEdpVcxNVNTz8tTOpZXfXXoh9n7yQFvYZW
	cdH1n1MGSOErEcBOonakg==
Message-ID: <6599ad830803140712i1f9dede3yb0be99528934d974@mail.gmail.com>
Date: Fri, 14 Mar 2008 07:12:08 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Cc: "Pavel Emelyanov" <xemul@openvz.org>, "James Morris" <jmorris@namei.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Casey Schaufler" <casey@schaufler-ca.com>
In-Reply-To: <20080314135817.GE8744@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
	 <20080313131818.GA9771@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au>
	 <20080313143803.GA11265@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au>
	 <20080313224616.GA9139@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au>
	 <20080314014121.GA8320@sergelap.austin.ibm.com>
	 <47DA4533.8030106@openvz.org>
	 <20080314135817.GE8744@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 6:58 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>  James and Stephen agree with your LSM qualms.  I suppose we could add
>  cgroups next to the lsm hooks.  I suspect Paul Menage would complain
>  about that (Paul?),

Depends on what you mean by "add cgroups to the LSM hooks". Could you
expand on that?

Paul
