Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYIHKzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYIHKzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYIHKzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:55:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51453 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYIHKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:55:43 -0400
To: Tony Vroon <tony@vroon.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
From: Andi Kleen <andi@firstfloor.org>
References: <1220754742.8530.12.camel@localhost>
Date: Mon, 08 Sep 2008 12:55:40 +0200
In-Reply-To: <1220754742.8530.12.camel@localhost> (Tony Vroon's message of "Sun, 07 Sep 2008 03:32:22 +0100")
Message-ID: <87abeivrdf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon <tony@vroon.org> writes:

> HARDWARE ERROR. This is *NOT* a software problem!
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Please contact your hardware vendor
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> I realize that the linux kernel may be entirely blameless in this
> situation,

It is, like mcelog told you.

> but I'd like to have some peer insight before I run after
> vendors.

It unfortunately turns out that mcelog logging is a tricky
psychological problem. How should the warning above have
looked like so that you would not have required "peer insight"
and actually just contacted your hardware vendor? 

Thank you.

-Andi (who wonders if <blink> tags in syslog would be useful 
to solve this)
