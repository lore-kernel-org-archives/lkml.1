Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYGAHip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYGAHip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYGAHig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:38:36 -0400
Received: from anguilla.debian.or.at ([86.59.118.152]:44186 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYGAHif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:38:35 -0400
Date: Tue, 1 Jul 2008 09:38:33 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Adam Langley <agl@imperialviolet.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.25.6: warn_on_slowpath in tcp_input.c
Message-ID: <20080701073833.GT16698@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Adam Langley <agl@imperialviolet.org>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <20080630230954.GS16698@anguilla.noreply.org> <396556a20806301656ydc44e3ey6deb229ab69904@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <396556a20806301656ydc44e3ey6deb229ab69904@mail.gmail.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Adam Langley wrote:

> On Mon, Jun 30, 2008 at 4:09 PM, Peter Palfrader <peter@palfrader.org> wrote:
> > I've had 13 or so of them since upgrading the machine to a 2.6.25 kernel
> > 20 days ago.
> 
> Which kernel was it running before?

It was running 2.6.22.17 (+ the splice fix) before that.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
