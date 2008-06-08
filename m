Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYFHGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYFHGcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYFHGcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 02:32:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28743 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFHGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 02:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lh7eKeqHHXgEXeLkYQiATrqg8TKM+rDU0q01AHtvG/qmdgPwvjqSrcArTNpnyKFsLh
         TuK7hhwWIl9nwDxw/3VfqtvLLIdvL0UTRdhuAUJsDgnGBRBq33+A7Raje45heo2rE1cn
         DA9Q6Rn+zu7QcXuFqS8hc3CZ+kCF6lAqrKvak=
Date: Sun, 8 Jun 2008 08:31:07 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCH] v4l: saa7134: fix multiple clients access (and
	oops)
Message-ID: <20080608063104.GA5608@joi>
References: <20080607224835.GA25025@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607224835.GA25025@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 12:48:35AM +0200, Marcin Slusarz wrote:
> (...)

This patch is stupid. Please ignore.

Marcin
