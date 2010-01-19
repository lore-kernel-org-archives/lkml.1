Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153Ab0ASMxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0ASMxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522Ab0ASMw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:52:59 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:48091 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0ASMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:52:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oGGFTInuum5DGlReyfcLo2WBYROsYSNv1ck0++o2hateQK6sams7GcWTn14BD6eU3g
         nTQ5pFGLVhV4ww4Ju3IeQaA1o4YBIW1Qtu7Ycv7We+2l/KEL0W48BVW1Va+JuZMvGeHE
         Qz97UB595SMl2X0RNM+veZt0BDKx9M+in5IH8=
MIME-Version: 1.0
Date: Tue, 19 Jan 2010 14:52:57 +0200
Message-ID: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
Subject: how do YOU hack the linux kernel ?
From: Ramagudi Naziir <naziirr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do you use vim ?

If so, how do you open files you want to read/edit ?
Assuming you don't remember their exact name/location, you'd need to
use something like 'find . -iname '*pattern*'. which is slow.
You can also ":tabnew ." and just browse the folders, but that's super slow too.


so, do you use stuff like 'Source Insight' ?

It does have a great files viewer, where you can just type a few
letters, and it immediately shows only files that match the pattern
you typed (just like in iTunes). This is blazing fast. But it's Source
Insight. you need to fight it not to over-visualizes your file, and
not to mess up with your whitespace. not to mention that it's
windows-only (although wine seems to help here a bit).


so.. back to vim ? It does have relevant plugins that tries to give
you fast files opener, like the 'project' plugin (totally unmaintained
and buggy) or the 'tselectfiles' plugin (slow, hard to use).


I'd really like to use vim, it's fast and gives you control, but
really I must have some way to quickly access my files.


Any ideas ?
