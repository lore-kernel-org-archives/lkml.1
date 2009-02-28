Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZB1HkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZB1HkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZB1Hj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:39:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:53443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZB1Hj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:39:56 -0500
Message-ID: <49A8EA1A.50802@kernel.org>
Date: Fri, 27 Feb 2009 23:39:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: does boot loader check uncompressed kernel size?
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>
In-Reply-To: <20090228071534.GB9351@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wonder if boot loader check uncompress size aka vmlinux size in bzImage
before it find one good position for bzImage...?

YH
