Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYEaAGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYEaAGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYEaAGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:06:14 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:53040 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751303AbYEaAGN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:06:13 -0400
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
Subject: Re: [PATCH] kaweth: use request_firmware()
References: <1211708969@pmac.infradead.org>
	<FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org>
	<20080530164842.31b23848@core> <200805302302.27890.oliver@neukum.org>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Fri, 30 May 2008 21:00:05 -0300
In-Reply-To: <200805302302.27890.oliver@neukum.org> (Oliver Neukum's message of "Fri\, 30 May 2008 23\:02\:25 +0200")
Message-ID: <or8wxre41m.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30, 2008, Oliver Neukum <oliver@neukum.org> wrote:

> If that is supposed to be constructed from the driver/file pair,
> it is a good idea, but would argue against hardcoding it in the source.

It's not.  It could be named dwmw2-rulez-new-fix or
dwmw2/rulez/new/fix or anything else, it's just a key, a string, an
identifier.  Any pathnames or relationship with driver names you're
seeing there are just a figment of your imagination ;-) / 2

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
