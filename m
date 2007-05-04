Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXEDNhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXEDNhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXEDNhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:37:16 -0400
Received: from smtp-out2.libero.it ([212.52.84.42]:59729 "EHLO
	smtp-out2.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbXEDNhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:37:14 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
Date: Fri, 4 May 2007 15:37:01 +0200
From: Salvatore De Paolis <depaolis.salvatore@libero.it>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel parameters: root
Message-ID: <20070504153701.43123c02@debian>
Organization: Debian Linux
X-Mailer: Claws Mail 2.9.1cvs35 (GTK+ 2.10.11; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEUAKQB8FQC2NADbSQD6Ygr+dxn/iyn/pkL/ynQAAQDr4pu+AAAAAXRSTlMAQObYZgAAAltJREFUOMtNk81x4zAMhd2CfdujqWQLICgXYILaewTIBcSiKwipCla+puN9FClvMNKMjU94+CF4OBwuy7NZnoWZVb05FBt2f7qPRByCBruBPy0iie16BpjUV9D8ak0HnaBxlh8gR6aekSPoFCu4Ff+alUdyDk+Y4r2BHHPOUTy5q0H2Kc4VJNVHzkmoc7ZzrLEBHSlMy5qY3n0fmKdHA57w57l+jSOzg9BjBx2zHQAEbhb4d+DU2stzTXPYSs35BTwRpFKaJo2o4gWIHN+WFXXFXP2tQeMC39BhtZRTmrWCXsPjue6kKNWIbohxeYH0A9ygDFCyFBSj8gbebrmcSNPHE2ffwDNv84VI2lLo2MB2hEUEJKHx2x6R1xKB6acINyIq6MKyLM+/S4oor9jMVPsIj3XJ6yN+TkULRUndklOPciExCr6epqQ3XyOObsiPVHYNZ6d4ZawRRyraOCUdhl718uWpbuKx8xAqixMGGQNq+qjAGI4PhX/Su4gOPNpzTW7cJWIBiwk5vObcIpAEvll7su+9ent+AT9LwOIE/GT+MDsg7LIwERkSwcobc6pn7jphBeh757zQb2OObRlwXaCDl0Wuo92lyGNpkUIUTLy77BHejMip5fq5ADFrjg14McYHlGkpsKcX6PBNSWIxAhHvzbkBS9biWoarMU7Y9y9AisrfGJNA84K+jw04b6xDXYorK+j+fPzVkpNlABzR/VO2mloEo+nOEt/vs3JVagBKzvfosfeb//v4vQGB0tV2NAaHHraAFuGh5XpfxmpOp/9gpHeMAq2cTLEG/gGlWSVVOcldhwAAAABJRU5ErkJggg==
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I hope this is the right place to ask this question, if not please redirect me
to the right ML.

I would like to know more about kernel parameters and in particular about the
root parameter.
I'm booting the kernel from usb pen and the root could change while the pen is
plugged in different machines with different hardware.
I was trying to find info about "how to make this unique". 
Does the kernel see only /dev/* ? There's no way to pass /dev/disk/*?

Any help/links is apprecciated
S.
