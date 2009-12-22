Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZLVLrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZLVLrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZLVLrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:47:14 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:38390 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZLVLrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:47:13 -0500
Date: Tue, 22 Dec 2009 12:47:11 +0100
From: Peter Palfrader <weasel@debian.org>
To: linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>
Subject: Re: 2.6.32.1: BUG and panic: unable to handle kernel NULL pointer dereference at 000000000000001f
Message-ID: <20091222114711.GL13850@anguilla.noreply.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	DSA <debian-admin@lists.debian.org>
References: <20091215162736.GS13850@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091215162736.GS13850@anguilla.noreply.org>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Peter Palfrader wrote:

> we tried to upgrade a couple of our proliant servers from 2.6.31.6 to
> 2.6.32.1.
> 
> On two of our DL385g1 servers we had problems booting 2.6.32.1, as they
> paniced.

Several more do not boot .32 reliably.  Anything I can try?

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
