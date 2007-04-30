Return-Path: <linux-kernel-owner+w=401wt.eu-S1423297AbXD3O1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423297AbXD3O1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423298AbXD3O1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:27:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56911 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423297AbXD3O1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:27:49 -0400
Subject: Re: Greylisting
From: David Woodhouse <dwmw2@infradead.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46350565.4050801@simon.arlott.org.uk>
References: <46350565.4050801@simon.arlott.org.uk>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 15:27:43 +0100
Message-Id: <1177943263.3085.93.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 21:51 +0100, Simon Arlott wrote:
> This is really starting to annoy me. The LKML itself does it too...

That's strange. After first seeing that a given host does actually queue
and resend, there's really not a lot of point in ever delaying more mail
from that host.

-- 
dwmw2

