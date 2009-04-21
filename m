Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZDUU53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZDUU53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZDUU5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:57:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZDUU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:57:19 -0400
Date: Tue, 21 Apr 2009 13:54:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz,
       ubuntuLp-ugeuder@sneakemail.com
Subject: Re: [PATCH] vgacon: Return the upper half of 512 character fonts
Message-Id: <20090421135454.6ac430fb.akpm@linux-foundation.org>
In-Reply-To: <49EDDB8E.5020200@canonical.com>
References: <49EDDB8E.5020200@canonical.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 16:43:26 +0200
Stefan Bader <stefan.bader@canonical.com> wrote:

> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Fri, 17 Apr 2009 23:21:05 +0200
> Subject: [PATCH] vgacon: Return the upper half of 512 character fonts
> 
> Bug: #355057

I think it's OK (and often good) to include the bug references in the
changelog.  But nobody will have any clue which bug tracking system
this refers to!

A full URL would be appropriate.

<googles for a while>

The form I use is

	Addresses https://bugs.launchpad.net/ubuntu/+source/linux/+bug/355057

