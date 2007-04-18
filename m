Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXDRA2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXDRA2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXDRA2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:28:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:24897 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXDRA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A78zaoAg/nLfu4Or0isL5Hxe7sHYRK7LetALE/6wUMWYqFzwyVjzRwz3SCbNU7XOTQIyrZW70nysg3TfZLrSFqKzjt46xO+cIFuqiQXgCHH4Wv3RuFwW9FuvFEM5LNWLyEUK92wq7F3DAC5ml1oRmMMlXPM6bpnogi3xG3TGyUQ=
Message-ID: <b6a2187b0704171728u4f7b7c08o7374fee8a7c3e2a5@mail.gmail.com>
Date: Wed, 18 Apr 2007 08:28:04 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jasper Spaans" <jasper@vs19.net>
Subject: Re: 4GB Physical. Less than 3GB in Linux.
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <837c0d330704171126n551010d7v6759fc9a516878ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.wZS4ieAkOMvNOj61QiUn9aS+YeM@ifi.uio.no>
	 <46238936.3060501@shaw.ca>
	 <b6a2187b0704160752u1c837f33p652c0d431b66459@mail.gmail.com>
	 <837c0d330704171126n551010d7v6759fc9a516878ab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/07, Jasper Spaans <jasper@vs19.net> wrote:

> Might be a setting in the bios... look for something like memory hole,
> memory remapping, 4G DRAM, etc.

I checked. BIOS says 4GB. No memory hole setting. But I'll play around
a bit more.

Thanks,
Jeff.
