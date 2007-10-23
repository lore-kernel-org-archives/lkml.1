Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXJWJSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXJWJSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXJWJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:18:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47048 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXJWJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:18:33 -0400
Date: Tue, 23 Oct 2007 11:18:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Giacomo A. Catenazzi" <cate@debian.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <471DBB75.9020605@debian.org>
Message-ID: <Pine.LNX.4.64.0710231117260.16684@fbirervta.pbzchgretzou.qr>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <471D8A4C.3020101@debian.org> <Pine.LNX.4.64.0710231051090.16684@fbirervta.pbzchgretzou.qr>
 <471DBB75.9020605@debian.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 23 2007 11:14, Giacomo A. Catenazzi wrote:
>> So, we give caps to the subadmins (which is IMHO a natural task),
>> and then, as per LSM design (wonder where that is written) deny
>> some of the rights that the capabilities raised for subadmins grant,
>> because that is obviously too much.
>
> Nothing wrong.  I only said that it was against (IIRC) the
> principle of LSM in kernel (we should only remove capacities).

Leave my capacitance alone! :)
[i hope you get the joke]

Anyway - I see your point. But what would give the user the capabilities
in the first place, if not a security module that implements this-and-that
capability-raising scheme?
