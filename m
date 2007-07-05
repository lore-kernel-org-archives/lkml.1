Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbXGEWOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbXGEWOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbXGEWNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:13:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbXGEWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:13:55 -0400
Message-ID: <468D6D1F.4040008@zytor.com>
Date: Thu, 05 Jul 2007 15:13:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gautam Singaraju <gautam.singaraju@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
In-Reply-To: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautam Singaraju wrote:
> I use the _syscall0 macro.

Don't.  The _syscall*() macros have been unsupported for ages, and
broken for ever longer.

	-hpa
