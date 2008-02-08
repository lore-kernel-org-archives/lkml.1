Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbYBHRTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbYBHRTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934668AbYBHRHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:07:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:56398 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934639AbYBHRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qEyovMtXZCUFs285LSFWZCElQTTwntgQN1LpUhpacVL9IU6JCVoN83DuzhdgpnXsz5C/MHyKSCaOqL1jIutNklwDyYRDq/tTte/m6MQjf3KJcOgV/bxVIcfYonmBUnziCy3mTqvTGIBHYJ+DL1VSj/vv6pX21jo52mOuk5MgwI8=
Message-ID: <84144f020802080907n268adc2bx7880b37919d61e78@mail.gmail.com>
Date: Fri, 8 Feb 2008 19:07:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/patch-tags, one more time
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <9525.1202489479@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9525.1202489479@vena.lwn.net>
X-Google-Sender-Auth: 9900427dbf24eaf9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 8, 2008 6:51 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> Somebody recently asked me about this patch, so I dug it up for one last
> try.  I do believe there is value in describing patch tags, and,
> certainly, nobody has objected to the idea.  Comments from several
> reviewers were addressed before the previous posting.

Andrew, can we please get this patch merged? People seem to be abusing
"Signed-off-by" for these things so it would be nice to have it
documented in the official kernel tree. Thanks.

                         Pekka
