Return-Path: <linux-kernel-owner+w=401wt.eu-S937198AbXG0MaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937198AbXG0MaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbXG0MaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:30:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52909 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762327AbXG0MaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:30:09 -0400
Date: Fri, 27 Jul 2007 13:30:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       rmk@arm.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
Message-ID: <20070727123007.GY27237@ftp.linux.org.uk>
References: <200707270944.LAA17082@ifs.emn.fr> <20070727095905.GU27237@ftp.linux.org.uk> <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr> <b6fcc0a0707270507u1c77e093y30d9bd5bddfa9054@mail.gmail.com> <Pine.LNX.4.64.0707271418390.12711@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707271418390.12711@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 02:18:59PM +0200, Jan Engelhardt wrote:
> >bool variables are rarely named buf, so no.
> 
> Whatever. Java is good in one point: the ! operator requires a bool.

Language and style advocacy -> that way.  Use of scalar types, including
pointers, in conditional contexts is both 100% legal and, what's more
important, idiomatic C.
