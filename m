Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbZLOXhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbZLOXhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760745AbZLOXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:37:21 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44828 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760714AbZLOXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c9FAMDM8HwPFrDLVixBsA4Dx89XBu1BsAZcNFsRTHPMsDoHCsNRgq7GENEL8QfN5Vk
         iFbR23ra1c1UIJaavsc2KydvP3IxW2zb1EXn4Cx7tOr9OYw/lU4YCkv07Dv2qcADd6VT
         F4cdGfT4RvJrefNMGPypt+UX6F3w5jBRJ3dmQ=
Date: Tue, 15 Dec 2009 17:51:29 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Fix kprobes build with non-gawk awk
Message-ID: <20091215235129.GA29712@progeny.tock>
References: <20091213220437.GA27718@progeny.tock>
 <4B2648E6.4050603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2648E6.4050603@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:

> Thank you for fixing it!

No problem.  Thanks for looking it over.

Regards,
Jonathan
