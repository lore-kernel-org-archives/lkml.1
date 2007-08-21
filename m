Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbXHUUuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbXHUUuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXHUUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:49:58 -0400
Received: from iona.labri.fr ([147.210.8.143]:38926 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbXHUUt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:49:57 -0400
Date: Tue, 21 Aug 2007 22:49:51 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070821204951.GC3658@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dtor@mail.ru
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jan Engelhardt, le Tue 21 Aug 2007 22:42:24 +0200, a écrit :
> >- keycodes: even before translation into keysym.
> 
> They can use the raw xlation for that.

For userland, yes.  This is for kernel modules.

Samuel
