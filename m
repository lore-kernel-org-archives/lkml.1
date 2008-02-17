Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYBQVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYBQVVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYBQVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:21:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYBQVVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:21:41 -0500
Message-ID: <47B8A538.5070803@zytor.com>
Date: Sun, 17 Feb 2008 13:20:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B9AF.2030006@zytor.com> <47B7BC4C.8070502@oracle.com> <200802172140.16055.rjw@sisk.pl>
In-Reply-To: <200802172140.16055.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> OK, so that would be the appended patch.
> 
> Still, since there are several fixes against the "move the wakeup code to C"
> patch, I'll probably fold them all into a new version of this patch and resend
> it.
> 

Yes, please.

	-hpa
