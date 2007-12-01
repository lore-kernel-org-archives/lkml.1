Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbXLAJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbXLAJu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 04:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXLAJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 04:50:09 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35822 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbXLAJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 04:50:07 -0500
Message-ID: <47512E48.7080509@davidnewall.com>
Date: Sat, 01 Dec 2007 20:20:00 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <47502595.4020007@redhat.com>
In-Reply-To: <47502595.4020007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Ben Crowhurst wrote:
>> Has Objective-C ever been considered for kernel development?
>
> No.  Kernel programming requires what is essentially assembly language 
> with a lot of syntactic sugar, which C provides.

I somewhat disagree.  Kernel programming requires and deserves the same 
care, rigor and eye to details as all other serious systems.  Whilst 
performance is always a consideration, high-level languages give a 
reward in ease of expression and improved reliability, such that a 
notional performance cost is easily justified.  Occasionally, precise 
bit-diddling or tight timing requirements might necessitate use of 
assembly; even so, a lot of bit-diddling can be expressed in high-level 
languages.

Kernel programming might require a scintilla of assembly language, but 
the very vast majority of it should be written in a high-level language.

There's an old joke that claims, "real programmers can write FORTRAN in 
any language."  It's true.  Object orientation is a style of 
programming, not a language, and while certain languages have intrinsic 
support for this style, objects, methods, properties and inheritance can 
be probably be written in any language.  It's an issue of putting in 
care and eye to detail.

Linux could be written in Objective-C, it could be written in Pascal, 
but it is written in plain C, with a smattering of assembler.  Does it 
need to be more complicated than that?
