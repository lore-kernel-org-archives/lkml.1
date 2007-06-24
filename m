Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbXFXWIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbXFXWIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXFXWIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:08:48 -0400
Received: from smtp-out3.libero.it ([212.52.84.43]:49737 "EHLO
	smtp-out3.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:08:48 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKeHfkaXLETW/2dsb2JhbACtSA
Date: Mon, 25 Jun 2007 00:08:46 +0200
From: Salvatore De Paolis <depaolis.salvatore@libero.it>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
Message-ID: <20070625000846.25f9a46f@debian>
In-Reply-To: <467EE48D.5010204@arndnet.de>
References: <20070624232734.28829225@debian>
	<Pine.LNX.4.64.0706242328520.11964@fbirervta.pbzchgretzou.qr>
	<467EE48D.5010204@arndnet.de>
Organization: Debian Linux
X-Mailer: Claws Mail 2.9.2cvs72 (GTK+ 2.10.13; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEUAKQB8FQC2NADbSQD6Ygr+dxn/iyn/pkL/ynQAAQDr4pu+AAAAAXRSTlMAQObYZgAAAltJREFUOMtNk81x4zAMhd2CfdujqWQLICgXYILaewTIBcSiKwipCla+puN9FClvMNKMjU94+CF4OBwuy7NZnoWZVb05FBt2f7qPRByCBruBPy0iie16BpjUV9D8ak0HnaBxlh8gR6aekSPoFCu4Ff+alUdyDk+Y4r2BHHPOUTy5q0H2Kc4VJNVHzkmoc7ZzrLEBHSlMy5qY3n0fmKdHA57w57l+jSOzg9BjBx2zHQAEbhb4d+DU2stzTXPYSs35BTwRpFKaJo2o4gWIHN+WFXXFXP2tQeMC39BhtZRTmrWCXsPjue6kKNWIbohxeYH0A9ygDFCyFBSj8gbebrmcSNPHE2ffwDNv84VI2lLo2MB2hEUEJKHx2x6R1xKB6acINyIq6MKyLM+/S4oor9jMVPsIj3XJ6yN+TkULRUndklOPciExCr6epqQ3XyOObsiPVHYNZ6d4ZawRRyraOCUdhl718uWpbuKx8xAqixMGGQNq+qjAGI4PhX/Su4gOPNpzTW7cJWIBiwk5vObcIpAEvll7su+9ent+AT9LwOIE/GT+MDsg7LIwERkSwcobc6pn7jphBeh757zQb2OObRlwXaCDl0Wuo92lyGNpkUIUTLy77BHejMip5fq5ADFrjg14McYHlGkpsKcX6PBNSWIxAhHvzbkBS9biWoarMU7Y9y9AisrfGJNA84K+jw04b6xDXYorK+j+fPzVkpNlABzR/VO2mloEo+nOEt/vs3JVagBKzvfosfeb//v4vQGB0tV2NAaHHraAFuGh5XpfxmpOp/9gpHeMAq2cTLEG/gGlWSVVOcldhwAAAABJRU5ErkJggg==
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 23:39:25 +0200
Arnd Hannemann <arnd@arndnet.de> wrote:

> use run-init from klibc?
 
> However be aware of the limitation of run-init:
> It only works for direct childs of root directory
> /mnt/newroot won't work
> /newroot should work ;-)
> 
> Good luck,
> Arnd

Thank you both, i'll take a look at run-init:)
Nice to know about the child limitation but i just have to find klibc-utils
inside buildroot or busybox if even exists:)

Regards
S.
