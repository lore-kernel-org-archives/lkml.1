Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbZFKQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbZFKQbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZFKQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:31:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42880 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZFKQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:31:08 -0400
Subject: Re: [PATCH] init: introduce mm_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
In-Reply-To: <alpine.DEB.1.10.0906111157081.24376@gentwo.org>
References: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906111157081.24376@gentwo.org>
Date: Thu, 11 Jun 2009 19:31:09 +0300
Message-Id: <1244737869.6281.9.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 11:57 -0400, Christoph Lameter wrote:
> You forgot to move it to mm/mm_init.c

OK, but that needs to wait for another day. The patch series is already
getting pretty big and there's no mminit.h in include/linux for this.

			Pekka

