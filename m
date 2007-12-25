Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXLYOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXLYOnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 09:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXLYOnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 09:43:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18445 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXLYOng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 09:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=A4d9OcTNxpxAyxKkzN6WgIaUeuuj/M1Dp0UVO8oKOyUFzGcdRk0Yc6KEG/d1ln8ZPwjOoMSFyNJ7VZOBTmJXkQhTPwKWeNY7FHB5bxicJhB1i0F3uB39HZY6C6JEG+j9j/E8AxlRBG86VLQRn/iMO9u4YRaB2sPbEo/3wO9w3Mc=
Date: Tue, 25 Dec 2007 15:45:17 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/6] udf: remove some ugly macros
Message-ID: <20071225144513.GA24373@joi>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com> <1198455022-27674-3-git-send-email-marcin.slusarz@gmail.com> <20071225115438.GA8296@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071225115438.GA8296@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 11:54:38AM +0000, Christoph Hellwig wrote:
> Looks generally good, but it would be nice if you could avoid
> introducing new overly long lines.  Then again this really won't be
> noticed in udf anyway and it looks like you plan to clean it up later
> anyway.
Yes, that's what I'm going to do.

> (in case it wasn;'t clear count this as an ack from me)
>
Thanks for review!

Marcin
