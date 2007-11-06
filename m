Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbXKFFtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbXKFFtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXKFFtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:49:13 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:8819 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXKFFtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CGoFASs1ab3PpaKWXFQzONSU51U+mueaNcGWz3Df2O7TUyf/oqoaSlLFtqBNhRUA7etEbNG4FjSEcbhWnrDLx5LnqKxba5EGmLhvix2pjM11q4O6YQ8PKWj2tEBQSmxWvhbZOP8fZWS0roPG/Tz+gteJTSu9Ss82lbR6Di9wcok=
Message-ID: <9e0cf0bf0711052149t5c9fe50j19d13e368690efb@mail.gmail.com>
Date: Tue, 6 Nov 2007 07:49:11 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [Bluez-devel] [BUG] rfcomm]
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <a8e1da0711051849ma591d4k6a816e2de7390347@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <a8e1da0711042108r7cea1a46s8d8b93795c314119@mail.gmail.com>
	 <9e0cf0bf0711050746s5f7910d8teb3c8ae9530b549e@mail.gmail.com>
	 <a8e1da0711051748u4a0d2d57t4bad26e4f02f559e@mail.gmail.com>
	 <a8e1da0711051849ma591d4k6a816e2de7390347@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
> sorry for reply again, this seems a diffrent issue ...

All that I do is running pppd over the rfcomm, suspending the system and resume.
I don't load any binary module.

Alon.
