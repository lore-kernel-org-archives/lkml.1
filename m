Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXBRFTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXBRFTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 00:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933117AbXBRFTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 00:19:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbXBRFTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 00:19:21 -0500
To: davids@webmaster.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
References: <MDEHLPKNGKAHNMBLJOLKKEKKBKAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 18 Feb 2007 03:15:10 -0200
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEKKBKAC.davids@webmaster.com> (David Schwartz's message of "Sat\, 17 Feb 2007 06\:19\:07 -0800")
Message-ID: <orire0dp29.fsf@free.oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> On Saturday 17 February 2007 03:42, David Schwartz wrote:
>> 
>> > Again, see Lexmark v. Static Controls. If "make a toner cartridge
>> > that works with a particular Lexmark printer" is a functional
>> > idea, why is "make a graphics driver that works with a particular
>> > Linux kernel" not? What is the difference you think matters?

>> That you cannot build such modules without integrating parts of
>> actual Linux kernel code (via #includes etc), whereas you can build
>> compatible toner cartridges without using any original component.

> Static Controls actually put a copy of Lexmark's 'Toner Loading Program' on
> each compatible cartridge they made. The printer actually copies the TLP off
> the cartridge. In other words, to make a compatible catridge, you do have to
> use an original component. (Or at least, it's much more difficult not to.)

Besides, you *can* build a module for Linux without using any kernel
code.  It just takes a lot of work to implement all you'd otherwise
need from the kernel in a clean-room fashion.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
