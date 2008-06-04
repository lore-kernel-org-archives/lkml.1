Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYFDDNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYFDDNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYFDDNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:13:23 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:19503 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYFDDNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KxaecMFNlm9gdUXfQWSE4RQb3WvgPOu6pSS002GqKdBbugNAMkcsUnx1kXLAwRfNFt/vo9/P1C0POXKfqkHytoPhC99tf2vE4rknLo4hd+CWkjeLjSDuFhDQcoX3bCAJUTBZf9dkeNcpKf1ODilLLkgz3hKHl4Du7wpRydCMwRc=
Date: Tue, 3 Jun 2008 22:13:09 -0500
From: Josh Boyer <jwboyer@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
Message-ID: <20080603221309.5e2762be@vader.jdub.homelinux.org>
In-Reply-To: <1212541541.4042.41.camel@shinybook.infradead.org>
References: <48447615.5050806@am.sony.com>
	<1212500751.16924.322.camel@pmac.infradead.org>
	<4845DB46.3020308@am.sony.com>
	<1212538597.4042.29.camel@shinybook.infradead.org>
	<20080603200349.3b1957e1@vader.jdub.homelinux.org>
	<1212541541.4042.41.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 02:05:40 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2008-06-03 at 20:03 -0500, Josh Boyer wrote:
> > On Wed, 04 Jun 2008 01:16:37 +0100
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Tue, 2008-06-03 at 17:01 -0700, Tim Bird wrote:
> > > > This is clearly an improvement. But it is missing this part of the
> > > > original patch:
> > > 
> > > Oops, well spotted. I've updated the patch in the git tree; thanks.
> > 
> > What git tree?
> 
>  git.infradead.org/embedded-2.6.git

Do you have plans to get that in -mm, or linux-next?

(Please say yes).

josh
