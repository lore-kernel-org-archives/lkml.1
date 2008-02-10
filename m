Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYBJUay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYBJUay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYBJUap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:30:45 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:47686 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbYBJUao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:30:44 -0500
From: Duncan Sands <baldrick.bulk@free.fr>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
Date: Sun, 10 Feb 2008 21:30:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A9DD30.5040604@openvz.org> <200802071057.41201.baldrick.bulk@free.fr> <47AAD886.2000606@openvz.org>
In-Reply-To: <47AAD886.2000606@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802102130.45196.baldrick.bulk@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> Oh, I see. You're right - this race is possible... I'll fix that up
> if this patch works.

it seems to work fine.  Thanks again for doing this!

Best wishes,

Duncan.
