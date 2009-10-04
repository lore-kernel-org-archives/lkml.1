Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZJDHaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZJDHaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 03:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZJDHaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 03:30:20 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:55181 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZJDHaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 03:30:20 -0400
Date: Sun, 4 Oct 2009 09:29:43 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091004072942.GA5934@boogie.lpds.sztaki.hu>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
 <20091003110546.78958508@infradead.org>
 <40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
 <20091003223210.GA4193@boogie.lpds.sztaki.hu>
 <40101cc30910031554w40a0f93ata5decac55cbcba5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30910031554w40a0f93ata5decac55cbcba5c@mail.gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 12:54:03AM +0200, Matteo Croce wrote:

> Emulate? I can replace it with two plain NOPs.
> How can I do the "emulation"? trapping SIGILL?

No, emulate it in the kernel, so userspace never notices.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
