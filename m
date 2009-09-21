Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZIVOLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZIVOLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZIVOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:11:52 -0400
Received: from dan.rpsys.net ([93.97.175.187]:55985 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZIVOLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:11:50 -0400
Subject: Re: [PATCH] LED driver for Intel NAS SS4200 series
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, Rodney Girod <rgirod@confocus.com>
In-Reply-To: <1253118732-11944-1-git-send-email-dave@sr71.net>
References: <1253118732-11944-1-git-send-email-dave@sr71.net>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 22:21:40 +0100
Message-Id: <1253568100.564.25.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 09:32 -0700, Dave Hansen wrote:
> Changes from last version
> * Added dmi-basd hardware detection, and modparam
>   override for it
> * replaced DRIVER_NAME with KBUILD_MODNAME

Thanks for the DMI fix, I've queued this in the LEDs tree.

Cheers,

Richard
-- 
Richard Purdie
Intel Open Source Technology Centre

