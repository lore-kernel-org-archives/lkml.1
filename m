Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbYBUNI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbYBUNI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbYBUNHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:07:55 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:5077 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbYBUNHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:07:54 -0500
Subject: Re: [patch 3/3] s390: cleanup - drop .data.idt section in
	vmlinux.lds script
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: gorcunov@gmail.com, takata@linux-m32r.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080221115608.GA27508@uranus.ravnborg.org>
References: <20080220194123.114692303@gmail.com>
	 <20080220194444.348896940@gmail.com> <1203593173.3489.1.camel@localhost>
	 <20080221115608.GA27508@uranus.ravnborg.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 21 Feb 2008 14:07:46 +0100
Message-Id: <1203599266.3489.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 12:56 +0100, Sam Ravnborg wrote:
> On Thu, Feb 21, 2008 at 12:26:13PM +0100, Martin Schwidefsky wrote:
> > On Wed, 2008-02-20 at 22:41 +0300, gorcunov@gmail.com wrote:
> > > The section .data.idt is not used at all - so drop it.
> > > 
> > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > 
> > Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Martin - I expect you to take the patch as it only touches s390.
> OK?

Fine with me.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


