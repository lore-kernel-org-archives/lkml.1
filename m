Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXFYKwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXFYKwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXFYKwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:52:43 -0400
Received: from [195.140.143.145] ([195.140.143.145]:39702 "EHLO
	head.develog.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396AbXFYKwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:52:43 -0400
X-Greylist: delayed 1074 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 06:52:43 EDT
Date: Mon, 25 Jun 2007 12:34:44 +0200
From: Salvatore De Paolis <iwkse@claws-mail.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
Message-ID: <20070625123444.0f5a4855@debian>
Organization: Debian Linux
X-Mailer: Claws Mail 2.9.2cvs72 (GTK+ 2.10.13; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEUAKQB8FQC2NADbSQD6Ygr+dxn/iyn/pkL/ynQAAQDr4pu+AAAAAXRSTlMAQObYZgAAAltJREFUOMtNk81x4zAMhd2CfdujqWQLICgXYILaewTIBcSiKwipCla+puN9FClvMNKMjU94+CF4OBwuy7NZnoWZVb05FBt2f7qPRByCBruBPy0iie16BpjUV9D8ak0HnaBxlh8gR6aekSPoFCu4Ff+alUdyDk+Y4r2BHHPOUTy5q0H2Kc4VJNVHzkmoc7ZzrLEBHSlMy5qY3n0fmKdHA57w57l+jSOzg9BjBx2zHQAEbhb4d+DU2stzTXPYSs35BTwRpFKaJo2o4gWIHN+WFXXFXP2tQeMC39BhtZRTmrWCXsPjue6kKNWIbohxeYH0A9ygDFCyFBSj8gbebrmcSNPHE2ffwDNv84VI2lLo2MB2hEUEJKHx2x6R1xKB6acINyIq6MKyLM+/S4oor9jMVPsIj3XJ6yN+TkULRUndklOPciExCr6epqQ3XyOObsiPVHYNZ6d4ZawRRyraOCUdhl718uWpbuKx8xAqixMGGQNq+qjAGI4PhX/Su4gOPNpzTW7cJWIBiwk5vObcIpAEvll7su+9ent+AT9LwOIE/GT+MDsg7LIwERkSwcobc6pn7jphBeh757zQb2OObRlwXaCDl0Wuo92lyGNpkUIUTLy77BHejMip5fq5ADFrjg14McYHlGkpsKcX6PBNSWIxAhHvzbkBS9biWoarMU7Y9y9AisrfGJNA84K+jw04b6xDXYorK+j+fPzVkpNlABzR/VO2mloEo+nOEt/vs3JVagBKzvfosfeb//v4vQGB0tV2NAaHHraAFuGh5XpfxmpOp/9gpHeMAq2cTLEG/gGlWSVVOcldhwAAAABJRU5ErkJggg==
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 14:19:02 +0400
Michael Tokarev <mjt@tls.msk.ru> wrote:

> Salvatore De Paolis wrote:
> > 
> >> use run-init from klibc?
> >  
> > Thank you both, i'll take a look at run-init:)
> 
> By the way, busybox now includes similar applet,
> named switch_root.
> 
> /mjt

yeah, i saw it yesterday after a while. Anyway the problem got a solution,
everything seems to work just fine.

Regards
S.
