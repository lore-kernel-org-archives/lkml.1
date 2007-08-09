Return-Path: <linux-kernel-owner+w=401wt.eu-S937257AbXHIAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937257AbXHIAeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763828AbXHIAeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:34:10 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:61566 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763312AbXHIAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:34:08 -0400
Message-Id: <20070809003211.373543702@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 20:32:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 0/7] Modify lguest32 to make room for lguest64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been working on lguest64 and in order to do this, I had to move
a lot of the i386 specific out of the way.  Well, the lguest64 port
is still not ready to display, but before Rusty makes too many changes
I would like this in upstream so I don't have to keep repeating my
changes :-)


So this patch series moves lguest32 out of the way for other archs.

-- Steve

