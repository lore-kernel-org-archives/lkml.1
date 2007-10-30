Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbXJ3WPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbXJ3WPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXJ3WOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:14:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268AbXJ3WOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:14:19 -0400
Date: Tue, 30 Oct 2007 15:13:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       linux-serial@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 0/16] CRIS architecture: Correct compile errors
Message-Id: <20071030151356.3eaa197b.akpm@linux-foundation.org>
In-Reply-To: <20071030092636.GC11960@axis.com>
References: <20071030092636.GC11960@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:26:36 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> The following patchset makes it possible to compile for the
> CRIS architecture, at least when applied to the 2.6.23 kernel.
> 
> Most patches are trivial, but some are a bit more complex,
> like the changes to the CRIS ethernet and serial drivers.
> 
> I've separated the changes out to logical components to ease
> reviewing. Please send any comments or questions to me and
> Mikael Starvik.

Please carefully choose good titles for your patches.

Please certainly do not send sixteen patches all with the same title.

For these patches I have invented titles for you.

http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt goes into
details.
