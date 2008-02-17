Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYBQVqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYBQVqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYBQVqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:46:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41145 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYBQVqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:46:22 -0500
Date: Sun, 17 Feb 2008 22:46:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
Message-ID: <20080217214631.GA15753@uranus.ravnborg.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B9AF.2030006@zytor.com> <47B7BC4C.8070502@oracle.com> <200802172140.16055.rjw@sisk.pl> <20080217210710.GA15284@uranus.ravnborg.org> <47B8A557.9080901@zytor.com> <20080217212838.GA15631@uranus.ravnborg.org> <47B8A7B9.2060500@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B8A7B9.2060500@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:31:37PM -0800, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >
> >But I assume in less obvious way.
> >It is a bit more intuitive to error out on missing
> >-m32 support than gcc failing to support .code16
> >or some other inline assembler magic.
> >
> 
> No, you will get the message "the selected CPU doesn't support the 
> x86-64 architecture".
A bit confusing but acceptable.

	Sam
