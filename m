Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZJNHU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZJNHU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZJNHU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:20:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34632 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZJNHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:20:27 -0400
Date: Wed, 14 Oct 2009 09:19:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20091014071950.GF23248@one.firstfloor.org>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de> <20091014045851.GA32413@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014045851.GA32413@core.coreip.homeip.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, what kind of keyboard is this? I was playing today but I could not
> get my USB keyboards to report release of more than 1 key per report....

The log was with a PS/2<->USB adapter, with a PS/2 keyboard connected
to a USB port through it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
