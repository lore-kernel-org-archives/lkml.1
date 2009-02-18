Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZBRIpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZBRIpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZBRIp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:45:29 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:52134 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZBRIp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:45:28 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: linux-next: USB mouse won't work after resume.
Date: Wed, 18 Feb 2009 09:47:16 +0100
User-Agent: KMail/1.9.10
Cc: linux-input@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <200902172142.57302.oliver@neukum.org> <499B56D3.3080701@free.fr>
In-Reply-To: <499B56D3.3080701@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902180947.17338.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 February 2009 01:31:15 schrieb Laurent Riffard:
> > Please try the attached patch.
> > 
> >       Regards
> >               Oliver
> > 
> 
> This patch does fix the behaviour, my USB mouse now works after suspend/resume. Thanks.

Very good. I've submitted the patch.

	Thanks
		Oliver

