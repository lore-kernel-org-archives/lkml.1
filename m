Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYFKAHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYFKAHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYFKAHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:07:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:19705 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYFKAHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gXQEpsqpHQhB4S/EYksIM2sLlYFqBXJsWj+4UgWtka3sBXn/21HNobUHUuRXa7/2f5
         0cMD+fmV24dE8pf/3amGJmxFtuiZJLAJEUT91r/zf7ATozNcjS9cMC6Gvm/ropQuhqSV
         yKNvJuF4AFvpzuBPoLr1r0hhlMBw75d10gSbk=
Message-ID: <31e679430806101707s357e4b0dm79c3f9a95c784320@mail.gmail.com>
Date: Wed, 11 Jun 2008 03:07:30 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [ANNOUNCE] linux-staging tree created
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <20080610190540.GA25066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610190540.GA25066@kroah.com>
X-Google-Sender-Auth: de6fe3ed6177010b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Tue, Jun 10, 2008 at 10:05 PM, Greg KH <greg@kroah.com> wrote:
> Oh great, not yet-another-kernel-tree, just what the world needs...
>
> Yes, this is an announcement of a new kernel tree, linux-staging.  It is
> a quilt series of patches that can be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>
>
> In a long and meandering thread with some of the other kernel developers
> a week or so ago, it came up that there is no single place for companies
> and developers to put their code for testing while it gets cleaned up
> for submission into the kernel tree.  All of the different subsystems
> have trees, but they generally only want code that is about to go into
> this release, or the next one.  For stuff that is farther off, there is
> no place to go.

That's great. I started working on the test and measurement class
driver. Do you want me to send preliminary patches or just the final
one ?

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
