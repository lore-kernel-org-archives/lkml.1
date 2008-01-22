Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYAVWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYAVWKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYAVWJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:09:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYAVWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:09:58 -0500
Message-ID: <479669AF.6070707@zytor.com>
Date: Tue, 22 Jan 2008 14:09:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: factor out common s2ram wakeup code
References: <20080122193719.GA3791@elf.ucw.cz> <4796519C.6040501@zytor.com> <20080122205625.GC4317@elf.ucw.cz> <47965B13.9080705@zytor.com> <20080122212440.GF4317@elf.ucw.cz> <47966546.6040002@zytor.com> <20080122220301.GA8019@elf.ucw.cz>
In-Reply-To: <20080122220301.GA8019@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> Shared structure would be okay, plus I need pointer to beggining and
> end of code so that I can copy it to lowmem.
> 								Pavel

OK, that's easy.

	-hpa

