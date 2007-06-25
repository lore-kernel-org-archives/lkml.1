Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXFYFEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXFYFEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXFYFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:04:14 -0400
Received: from smtp-out3.libero.it ([212.52.84.43]:55442 "EHLO
	smtp-out3.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXFYFEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:04:13 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABbqfkaXLETW/2dsb2JhbACuHA
Date: Mon, 25 Jun 2007 07:04:12 +0200
From: Salvatore De Paolis <depaolis.salvatore@libero.it>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
Message-ID: <20070625070412.29a48843@debian>
In-Reply-To: <3FDD4C43-2F9A-46B3-BFA5-DC5E5A30D985@mac.com>
References: <20070624232734.28829225@debian>
	<3FDD4C43-2F9A-46B3-BFA5-DC5E5A30D985@mac.com>
Organization: Debian Linux
X-Mailer: Claws Mail 2.9.2cvs72 (GTK+ 2.10.13; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEUAKQB8FQC2NADbSQD6Ygr+dxn/iyn/pkL/ynQAAQDr4pu+AAAAAXRSTlMAQObYZgAAAltJREFUOMtNk81x4zAMhd2CfdujqWQLICgXYILaewTIBcSiKwipCla+puN9FClvMNKMjU94+CF4OBwuy7NZnoWZVb05FBt2f7qPRByCBruBPy0iie16BpjUV9D8ak0HnaBxlh8gR6aekSPoFCu4Ff+alUdyDk+Y4r2BHHPOUTy5q0H2Kc4VJNVHzkmoc7ZzrLEBHSlMy5qY3n0fmKdHA57w57l+jSOzg9BjBx2zHQAEbhb4d+DU2stzTXPYSs35BTwRpFKaJo2o4gWIHN+WFXXFXP2tQeMC39BhtZRTmrWCXsPjue6kKNWIbohxeYH0A9ygDFCyFBSj8gbebrmcSNPHE2ffwDNv84VI2lLo2MB2hEUEJKHx2x6R1xKB6acINyIq6MKyLM+/S4oor9jMVPsIj3XJ6yN+TkULRUndklOPciExCr6epqQ3XyOObsiPVHYNZ6d4ZawRRyraOCUdhl718uWpbuKx8xAqixMGGQNq+qjAGI4PhX/Su4gOPNpzTW7cJWIBiwk5vObcIpAEvll7su+9ent+AT9LwOIE/GT+MDsg7LIwERkSwcobc6pn7jphBeh757zQb2OObRlwXaCDl0Wuo92lyGNpkUIUTLy77BHejMip5fq5ADFrjg14McYHlGkpsKcX6PBNSWIxAhHvzbkBS9biWoarMU7Y9y9AisrfGJNA84K+jw04b6xDXYorK+j+fPzVkpNlABzR/VO2mloEo+nOEt/vs3JVagBKzvfosfeb//v4vQGB0tV2NAaHHraAFuGh5XpfxmpOp/9gpHeMAq2cTLEG/gGlWSVVOcldhwAAAABJRU5ErkJggg==
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So i choice to use switch_root which is already inside the busybox but with a
bit(?) of unluck cause it still wont run.

It hangs on !S_ISREG(st1.st_mode)

Can you explain to me how to interpret it?

Regards
S.
