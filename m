Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbXEIF5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbXEIF5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935050AbXEIF4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:56:52 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:40168 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935239AbXEIF4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QJqTVravwlNxjggg17d/ikeTXnAhUvIvmLLK0+RXWsNMHz8clc3Juepc8gu3f+Yuuk56aSwif35NxO2HK4im4PYgBdfTwrTSvUjKTP4mxtpJRWYzAIV+85rEL24Ar48Ko01X+yhwhrQkOXt5LCdM6dAmx7CzU8vdZ12PFB2gp8Q=
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46413851.6070505@zytor.com>
References: <46413851.6070505@zytor.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 13:56:33 +0800
Message-Id: <1178690193.4747.16.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 19:56 -0700, H. Peter Anvin wrote:
> Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
> modes if framebuffer is disabled" is just plain wrong on any system
> which has support for extended text modes in its VESA BIOS.
> 
> Antonio is incorrectly assuming this branchout is used only to set VESA
> graphics modes, but it's to set any VESA mode, be it text or graphics.
> 

Okay.

Tony


