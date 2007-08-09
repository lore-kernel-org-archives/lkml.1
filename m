Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXHIR4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXHIR4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXHIR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:56:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:15512 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbXHIR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QL2o+ZMUQm6kmEEMr3m8/RfBIr2trCVNKce/qAUsB8VhFQaJugt3myhO26hLhawGqX8C2z58Lr/+YIGTU9yt0ZGsXgOJ3C1Z5uYAJxWdCBVtKRZYu+asFU8FWw9DCGukFozUcnCjr3ItkMCLUxqwEpXfvk9X7lOkxlC+GRQG0uM=
Message-ID: <b6c5339f0708091056y2fca0857nd33f881b60cfce41@mail.gmail.com>
Date: Thu, 9 Aug 2007 13:56:03 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: Documentation files in html format?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070809113122.3aa508e4@oldman.hamilton.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809113122.3aa508e4@oldman.hamilton.local>
X-Google-Sender-Auth: 8997c557e2a4d7cc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> Since the network device documentation needs a rewrite, I was thinking
> of using basic html format instead of just plain text. But since this would
> be starting an new precedent for kernel documentation, some it seemed
> like a worthwhile topic for discussion.

Why not just use asciidoc?  Slightly worse than plain text, slightly
better than angle brackets everywhere.  Nothing is more annoying than
having to use lynx to read documentation because someone went tags
crazy.

-Bob
