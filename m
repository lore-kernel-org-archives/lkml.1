Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYBQVWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYBQVWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbYBQVVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:21:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbYBQVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:21:51 -0500
Message-ID: <47B8A557.9080901@zytor.com>
Date: Sun, 17 Feb 2008 13:21:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B9AF.2030006@zytor.com> <47B7BC4C.8070502@oracle.com> <200802172140.16055.rjw@sisk.pl> <20080217210710.GA15284@uranus.ravnborg.org>
In-Reply-To: <20080217210710.GA15284@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> For a 64 bit build we should error out if the compiler
> fials to support -m32 (how unlikely that may be).
> So I would prefer it unconditional for 64 bit.
> 

We will err out anyway.

	-hpa
