Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXICGh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXICGh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXICGhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:37:17 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:49836 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXICGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:37:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Oops in pwc v4l driver
Date: Mon, 3 Sep 2007 08:37:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: "Alex Smith" <lkml@alex-smith.me.uk>, linux-kernel@vger.kernel.org
References: <a0738740709020457n3490ee52l49d29712f3ddbb75@mail.gmail.com> <6bffcb0e0709021647m7ad694d7mf876bf4a6c8b4aca@mail.gmail.com>
In-Reply-To: <6bffcb0e0709021647m7ad694d7mf876bf4a6c8b4aca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709030837.21880.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 03 September 2007 schrieb Michal Piotrowski:
> Hi Alex,
> 
> On 02/09/07, Alex Smith <lkml@alex-smith.me.uk> wrote:
> > Hi,
> >
> > I found an old Philips Askey VC010 webcam and attempted to get it
> > working on Linux (latest git, x86_64).
> 
> Is this a regression? Does 2.6.22 work fine?

2.6.22 would fail in a different way. This is a question of definition.
A patch is available in any case.

	Regards
		Oliver



